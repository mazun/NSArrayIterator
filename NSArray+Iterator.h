#import <Foundation/Foundation.h>
#import <boost/iterator_adaptors.hpp>
#import <utility>

namespace ns_array_helper{
    template<typename Array, typename Index = int>
    struct iterator_info
    {
        typedef Index index_type;
        Array *array;
        Index index;
        
        iterator_info(){}
        iterator_info(Array *array, Index index)
        : array(array), index(index){}
        
        void operator ++ (){
            ++index;
        }

        void operator -- (){
            --index;
        }
        
        Index operator += (Index index){
            return this->index += index;
        }
        
        Index operator -= (Index index){
            return this->index -= index;
        }
        
        Index operator - (iterator_info const &other) const{
            return index - other.index;
        }
        
        bool operator == (iterator_info const &other) const{
            return array == other.array && index == other.index;
        }
    };
    
    template<typename Array, typename Index = int>
    struct reverse_iterator_info
    {
        typedef Index index_type;
        Array *array;
        Index index;
        
        reverse_iterator_info(){}
        reverse_iterator_info(Array *array, Index index)
        : array(array), index(index){}
        
        void operator ++ (){
            --index;
        }
        
        void operator -- (){
            ++index;
        }
        
        Index operator += (Index index){
            return this->index -= index;
        }

        Index operator -= (Index index){
            return this->index += index;
        }
        
        Index operator - (reverse_iterator_info const &other) const{
            return -(index - other.index);
        }
        
        bool operator == (reverse_iterator_info const &other) const{
            return array == other.array && index == other.index;
        }
    };
}

namespace ns_array{
    template<typename T, typename IteratorInfo>
    struct const_iterator_base
    : public boost::iterator_adaptor<
        const_iterator_base<T, IteratorInfo>,
        IteratorInfo,
        T,
        boost::random_access_traversal_tag,
        T,
        typename IteratorInfo::index_type
    >{
    private:
        friend class boost::iterator_core_access;

        T dereference() const{
            auto const &data = const_iterator_base::base_reference();
            return data.array[data.index];
        }
    public:
        const_iterator_base(){}
        const_iterator_base(IteratorInfo data)
        : const_iterator_base::iterator_adaptor_(data){
        }
    };
    
    typedef ns_array_helper::iterator_info<NSArray, int> iterator_info;
    typedef ns_array_helper::reverse_iterator_info<NSArray, int> reverse_iterator_info;

    typedef const_iterator_base<id, iterator_info> const_iterator;
    typedef const_iterator_base<id, reverse_iterator_info> const_reverse_iterator;
    
    const_iterator cbegin(NSArray *array);
    const_iterator cend(NSArray *array);

    const_reverse_iterator crbegin(NSArray *array);
    const_reverse_iterator crend(NSArray *array);
}

namespace ns_mutable_array{
    template<typename T, typename Index>
    struct iterator_proxy{
    private:
        NSMutableArray *array;
        Index index;
        T cache;
    public:
        iterator_proxy(NSMutableArray *array, Index index)
        : array(array), index(index), cache(array[index]){
        }

        iterator_proxy(iterator_proxy const &other)
        : array(other.array), index(other.index), cache(other.cache){
        }

        template<typename S>
        S operator = (S const &other){
            cache = array[index] = static_cast<T>(other);
            return other;
        }
        
        template<typename S>
        S operator = (S &&other){
            cache = array[index] = static_cast<T>(other);
            return other;
        }
        
        T operator = (iterator_proxy const &other){
            return (*this) = static_cast<T>(other);
        }

        T operator = (iterator_proxy &&other){
            return (*this) = static_cast<T>(other);
        }
        
        template<typename S>
        operator S () const{
            return static_cast<S>(cache);
        }
        
        template<typename S>
        bool operator == (S const &s){
            return cache == static_cast<T>(s);
        }
    };
    
    template<typename T, typename IteratorInfo>
    struct iterator_base
    : public boost::iterator_adaptor<
        iterator_base<T, IteratorInfo>,
        IteratorInfo,
        iterator_proxy<T, typename IteratorInfo::index_type>,
        boost::random_access_traversal_tag,
        iterator_proxy<T, typename IteratorInfo::index_type>,
        typename IteratorInfo::index_type
    >{
    private:
        friend class boost::iterator_core_access;
        
        iterator_proxy<T, typename IteratorInfo::index_type> dereference() const{
            auto const &data = iterator_base::base_reference();
            return iterator_proxy<T, typename IteratorInfo::index_type>(data.array, data.index);
        }
    public:
        iterator_base(){}
        iterator_base(IteratorInfo data)
        : iterator_base::iterator_adaptor_(data){
        }
    };
    
    typedef ns_array_helper::iterator_info<NSMutableArray, int> iterator_info;
    typedef ns_array_helper::reverse_iterator_info<NSMutableArray, int> reverse_iterator_info;

    typedef iterator_base<id, iterator_info> iterator;
    typedef iterator_base<id, reverse_iterator_info> reverse_iterator;
    
    iterator begin(NSMutableArray *array);
    iterator end(NSMutableArray *array);
    
    reverse_iterator rbegin(NSMutableArray *array);
    reverse_iterator rend(NSMutableArray *array);
    
    template<typename T, typename Index>
    void swap(iterator_proxy<T, Index> a, iterator_proxy<T, Index> b){
        const T val_a = static_cast<T>(a);
        a = static_cast<T>(b);
        b = val_a;
    }
}

@interface NSArray (Iterator)
- (ns_array::const_iterator(^)())begin;
- (ns_array::const_iterator(^)())end;
- (ns_array::const_reverse_iterator(^)())rbegin;
- (ns_array::const_reverse_iterator(^)())rend;
@end

@interface NSMutableArray (Iterator)
- (ns_mutable_array::iterator(^)())begin;
- (ns_mutable_array::iterator(^)())end;
- (ns_mutable_array::reverse_iterator(^)())rbegin;
- (ns_mutable_array::reverse_iterator(^)())rend;
@end
