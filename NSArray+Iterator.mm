#import "NSArray+Iterator.h"

namespace ns_array{
    const_iterator cbegin(NSArray *array){
        return const_iterator(iterator_info(array, 0));
    }
    
    const_iterator cend(NSArray *array){
        return const_iterator(iterator_info(array, static_cast<int>(array.count)));
    }
    
    const_reverse_iterator crbegin(NSArray *array){
        return const_reverse_iterator(reverse_iterator_info(array, static_cast<int>(array.count) - 1));
    }
    
    const_reverse_iterator crend(NSArray *array){
        return const_reverse_iterator(reverse_iterator_info(array, -1));
    }
}

namespace ns_mutable_array{
    iterator begin(NSMutableArray *array){
        return iterator(iterator_info(array, 0));
    }

    iterator end(NSMutableArray *array){
        return iterator(iterator_info(array, static_cast<int>(array.count)));
    }
    
    reverse_iterator rbegin(NSMutableArray *array){
        return reverse_iterator(reverse_iterator_info(array, static_cast<int>(array.count) - 1));
    }

    reverse_iterator rend(NSMutableArray *array){
        return reverse_iterator(reverse_iterator_info(array, -1));
    }
    
}

@implementation NSArray (Iterator)
- (ns_array::const_iterator(^)())begin{
    return ^{ return ns_array::cbegin(self); };
}

- (ns_array::const_iterator(^)())end{
    return ^{ return ns_array::cend(self); };
}

- (ns_array::const_reverse_iterator(^)())rbegin{
    return ^{ return ns_array::crbegin(self); };
}

- (ns_array::const_reverse_iterator(^)())rend{
    return ^{ return ns_array::crend(self); };
}
@end

@implementation NSMutableArray (Iterator)
- (ns_mutable_array::iterator(^)())begin{
    return ^{ return ns_mutable_array::begin(self); };
}
- (ns_mutable_array::iterator(^)())end{
    return ^{ return ns_mutable_array::end(self); };
}
- (ns_mutable_array::reverse_iterator(^)())rbegin{
    return ^{ return ns_mutable_array::rbegin(self); };
}
- (ns_mutable_array::reverse_iterator(^)())rend{
    return ^{ return ns_mutable_array::rend(self); };
}
@end
