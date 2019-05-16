
pragma solidity ^0.4.24;
// mapping 遍历库
library IterableMapping {
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
        uint value;
    }
 
 
    // 插入数据
    function insert(itmap storage self, d_storage key, uint value) returns(bool replaced) {
        uint keyIdx = self.data[key].KeyIndex;
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
    function remove(itmap storage self, d_storage key) returns(bool) {
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
    function iterate_get(itmap storage self, uint KeyIdx) returns(d_storage key, uint value) {
        key = self.keys[KeyIdx].key;
        value = self.data[key].value;
    }
 
    // 包含
    function iterate_contains(itmap storage self, d_storage key) returns(bool) {
        return self.data[key].KeyIndex > 0;
    }
 
    // 获取下一个索引
    function iterate_next(itmap storage self, uint _keyIndex) returns(uint r_keyIndex) {
 
        _keyIndex++;
        while(_keyIndex < self.keys.length && self.keys[_keyIndex].deleted) {
            _keyIndex++;
        }
        return _keyIndex;
    }
 
    // 开始遍历
    function iterate_start(itmap storage self) returns(uint keyIndex) {
        iterate_next(self, uint(-1));
    }
 
    // 循环退出条件
    function iterate_valid(itmap storage self, uint keyIndex) returns(bool) {
        return keyIndex < self.keys.length;
    }
}
contract ForkContract {
    IterableMapping.itmap credits;
    d_storage cache;
    address user;
    function sign_up(uint version,d_storage key)
    function insert(uint key, uint value) returns(uint size) {
        IterableMapping.insert(data, key, value);
        return data.size;
    }
    // 插入数据
    function insert(uint key, uint value) returns(uint size) {
        IterableMapping.insert(data, key, value);
        return data.size;
    }
 
    // 遍历求和
    function sum() returns(uint s) {
        for(var i = IterableMapping.iterate_start(data);
            IterableMapping.iterate_valid(data, i);
            i = IterableMapping.iterate_next(data, i)) {
            var (key ,value) = IterableMapping.iterate_get(data, i);
            s += value;
        }
    }

    mapping(address => uint) public credits;
    function forkContract() payable {
        user = 0x123;
        credits[user] = 10;
}
    function sign() public {

    }
    function update() public returns (uint64){
                uint64 a = 7;
                user = 0x123;
                d_storage d = user;
                a = d.sused(a);
                d_storage d2 = 0x456;
                a = 456;
                a = d2.sused(a);
                a=8;
//                d = user;
//                a = d.sused(credits[user]);
                return a;
    }
}

