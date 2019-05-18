//pragma experimental ABIEncoderV2;
pragma solidity ^0.4.24;
// mapping 遍历库
contract IterableMapping {
    // 增、删、改、查
    struct itmap {
        uint size;
        mapping(d_storage => IndexValue) data;
        KeyFlag []keys;
    }
 
    // key值的列表
    struct KeyFlag {
        d_storage key;
        bool deleted;
    }
 
    // value
    struct IndexValue {
        uint KeyIndex;
        user value;
    }

    struct user{
        uint version;
        uint credit;
    }
 
 
    // 插入数据
    function insert(itmap storage self, address keyCache, uint version, uint credit) public visible returns(bool replaced) {
        d_storage key = keyCache;
        uint keyIdx = self.data[key].KeyIndex;
        user memory value = user(version,credit);
        self.data[key].value = value;
        if (keyIdx > 0) {
            return true;
        }else {
            keyIdx = self.keys.length++;
            self.data[key].KeyIndex = keyIdx + 1;
            self.keys[keyIdx].key = key;
            self.size++;
            return false;
        }
    }
 
    // 删除数据(逻辑删除)
    function remove(itmap storage self, address keyCache) public visible returns(bool) {
        d_storage key = keyCache;
        uint keyIdx = self.data[key].KeyIndex;
        if (keyIdx == 0) {
            return false;
        } else {
            delete self.data[key]; //逻辑删除
            self.keys[keyIdx - 1].deleted = true;
            self.size --;
            return true;
        }
    }
 
    // 获取数据
    function iterate_get(itmap storage self, uint KeyIdx) public visible returns(address keyCache, uint version,uint credit) {
        keyCache = self.keys[KeyIdx].key;
        d_storage key = keyCache;
//        value = self.data[key].value;
        version = self.data[key].value.version;
        credit = self.data[key].value.credit; 
    }
 
    // 包含
    function iterate_contains(itmap storage self, address keyCache) public visible returns(bool) {
        d_storage key = keyCache;
        return self.data[key].KeyIndex > 0;
    }
 
    // 获取下一个索引
    function iterate_next(itmap storage self, uint _keyIndex) public visible returns(uint r_keyIndex) {
 
        _keyIndex++;
        while(_keyIndex < self.keys.length && self.keys[_keyIndex].deleted) {
            _keyIndex++;
        }
        return _keyIndex;
    }
 
    // 开始遍历
    function iterate_start(itmap storage self) public visible returns(uint keyIndex) {
        iterate_next(self, uint(-1));
    }
 
    // 循环退出条件
    function iterate_valid(itmap storage self, uint keyIndex) public visible returns(bool) {
        return keyIndex < self.keys.length;
    }
}
contract ForkContract {
    using IterableMapping for *;
    IterableMapping.itmap credits;
    address current;

    function sign_up(uint version) public returns(uint size){
        IterableMapping.user cache;
        current=msg.sender;
        d_storage d = current;
        cache.version=version;
        uint credit = credits.data[d].value.credit;
        if(credit <= 0){
            credit = 0;  
        }
        IterableMapping.insert(credits,d,version,credit);
        return credits.size;
    }

    function record(uint version) public{
        uint a =7;
        for(uint i = IterableMapping.iterate_start(credits);
        IterableMapping.iterate_valid(credits,i);
        i = IterableMapping.iterate_next(credits,i)){
            (d_storage key,uint ver, uint credit) = IterableMapping.iterate_get(credits,i);
            if(ver == version){
                a=key.sused(credit);
            }
        }
    }

//    function vote() public returns(bool result){ 赞成大于反对 最后还要调整分数 
//
//    }

// 插入数据
//    function insert(uint key, uint value) returns(uint size) {
//        IterableMapping.insert(data, key, value);
//        return data.size;
//    }
    // 遍历求和
//    function sum() returns(uint s) {
//        for(var i = IterableMapping.iterate_start(data);
//            IterableMapping.iterate_valid(data, i);
//            i = IterableMapping.iterate_next(data, i)) {
//            var (key ,value) = IterableMapping.iterate_get(data, i);
//            s += value;
//        }
//    }
//    function forkContract() payable {
//       user = 0x123;
//        credits[user] = 10;
//}
//    function update() public returns (uint64){
//                uint64 a = 7;
//                user = 0x123;
//                d_storage d = user;
//                a = d.sused(a);
//                d_storage d2 = 0x456;
//                a=8;
//                return a;
//    }
}

