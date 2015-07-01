#define BOOST_TEST_MAIN
#import <boost/test/included/unit_test.hpp>

#import <Foundation/Foundation.h>
#import <algorithm>
#import "NSArray+Iterator.h"

#import <boost/range/adaptors.hpp>
#import <boost/range/algorithm.hpp>
#import <boost/assert.hpp>

template<typename T>
bool NSNumberLess(NSNumber *lhs, NSNumber *rhs);

template<>
bool NSNumberLess<int>(NSNumber *lhs, NSNumber *rhs){
    return lhs.intValue < rhs.intValue;
}

bool eqNumbers(NSArray *lhs, NSArray *rhs){
    if(lhs.count != rhs.count){
        return false;
    }
    
    for(int i = 0; i < lhs.count; i++){
        if(((NSNumber *)lhs[i]).intValue != ((NSNumber *)rhs[i]).intValue){
            return false;
        }
    }
    
    return true;
}

bool eqNumber(NSNumber *lhs, NSNumber *rhs){
    return lhs.intValue == rhs.intValue;
}

struct NSMutableArrayFixture{
    NSMutableArray *array;
    NSMutableArrayFixture() : array([@[@6, @2, @1, @3, @4, @5] mutableCopy]){}
    ~NSMutableArrayFixture(){}
};

BOOST_AUTO_TEST_SUITE(NSMutableArrayTest)

BOOST_FIXTURE_TEST_CASE(sort, NSMutableArrayFixture){
    std::sort(array.begin(), array.end(), NSNumberLess<int>);
    BOOST_CHECK(eqNumbers(array, @[@1, @2, @3, @4, @5, @6]));

    std::sort(array.rbegin(), array.rend(), NSNumberLess<int>);
    BOOST_CHECK(eqNumbers(array, @[@6, @5, @4, @3, @2, @1]));
}

BOOST_FIXTURE_TEST_CASE(iterator, NSMutableArrayFixture){
    auto it = array.begin();
    BOOST_ASSERT(eqNumber(*it, @6));
    BOOST_ASSERT(eqNumber(*++it, @2));
    BOOST_ASSERT(eqNumber(*++it, @1));
    BOOST_ASSERT(eqNumber(*++it, @3));
    BOOST_ASSERT(eqNumber(*++it, @4));
    BOOST_ASSERT(eqNumber(*++it, @5));
    BOOST_ASSERT(++it == array.end());
}

BOOST_FIXTURE_TEST_CASE(find, NSMutableArrayFixture){
    auto it = std::find_if(array.begin(), array.end(), [](NSNumber *n){ return n.intValue == 3; });
    BOOST_ASSERT(it == array.begin() + 3);
    BOOST_ASSERT(eqNumber(*it, @3));
    
}

BOOST_FIXTURE_TEST_CASE(range_for, NSMutableArrayFixture){
    for(NSNumber *i : array){
        BOOST_ASSERT([i isKindOfClass:[NSNumber class]]);
    }
}

BOOST_AUTO_TEST_SUITE_END()

struct NSArrayFixture{
    NSArray *array;
    NSArrayFixture() : array(@[@6, @2, @1, @3, @4, @5]){}
    ~NSArrayFixture(){}
};

BOOST_AUTO_TEST_SUITE(NSArrayTest)

// cannot sort because NSArray is immutable.

BOOST_FIXTURE_TEST_CASE(iterator, NSArrayFixture){
    auto it = array.begin();
    BOOST_ASSERT(eqNumber(*it, @6));
    BOOST_ASSERT(eqNumber(*++it, @2));
    BOOST_ASSERT(eqNumber(*++it, @1));
    BOOST_ASSERT(eqNumber(*++it, @3));
    BOOST_ASSERT(eqNumber(*++it, @4));
    BOOST_ASSERT(eqNumber(*++it, @5));
    BOOST_ASSERT(++it == array.end());
}

BOOST_FIXTURE_TEST_CASE(find, NSArrayFixture){
    auto it = std::find_if(array.begin(), array.end(), [](NSNumber *n){ return n.intValue == 3; });
    BOOST_ASSERT(it == array.begin() + 3);
    BOOST_ASSERT(eqNumber(*it, @3));
}

BOOST_FIXTURE_TEST_CASE(range_for, NSArrayFixture){
    for(NSNumber *i : array){
        BOOST_ASSERT([i isKindOfClass:[NSNumber class]]);
    }
}

BOOST_AUTO_TEST_SUITE_END()
