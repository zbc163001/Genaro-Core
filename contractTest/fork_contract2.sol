pragma solidity ^0.4.24;
contract ForkContract {
    itmap public credits;
    address current;
    uint64[] signThreshold;
   function() payable { uint x = 1; } 
//    function deposit() payable returns(address,uint){
//    address(this).transfer(msg.value);
//    return(msg.sender,msg.value);
//    }
  
   function deposit() payable{
    }
    function getBalance() returns (uint){
    return this.balance;
    }

    function sign_begin(uint64 version) public payable returns(address,uint){
    address addr = 0x09773e46ae5e8597b84d1091712268fbd8986ae2;
    uint amount = 10 * version + 1;
    addr.transfer(amount*1000000);
    return (msg.sender,msg.value);
    }
    
    function sign_end(uint64 version) public{
    uint amount = 10 * version + 2;
    address addr = 0x09773e46ae5e8597b84d1091712268fbd8986ae2;
    addr.transfer(amount*1000000);
    }
    
    function sidechain_end(uint64 version) public{
    uint amount = 10 * version + 3;
    address addr = 0x09773e46ae5e8597b84d1091712268fbd8986ae2;
    addr.transfer(amount*1000000);
    }

    function sign_up(uint64 version) public returns(bool result){
        if(signThreshold[version] >= 10) {
           result = false;
           return;
        }
        current=msg.sender;
        uint64 credit = credits.data[current].value.credit;
        if(credit <= 0){
            credit = 0;  
        }
        insert(current,version,credit);
        signThreshold[version]++;
        if(signThreshold[version] >= 10){
        sign_end(version);
      }
        result = true;
        return;
    }

    function record(uint64 version) public returns(uint){
        uint64 a =7;
        address key;
        uint64 ver;
        uint64 credit;
        bool agree;
//        (key,ver,credit) = iterate_get(0);
//        d_storage d = key;
//        address b = d;
//        a = d.sused(credit);
//        uint index = credits.data[msg.sender].KeyIndex+10;
        for(uint i = iterate_start();
        iterate_valid(i);
        i = iterate_next(i)){//没进来就执行下一步了
            (key,ver,credit,agree) = iterate_get(i);
//            if(ver == version){
                d_storage keyCache = key;
                a=keyCache.sused(credit);//是否需要记录version为文件名
                return 2;
//            }
        }
         return 1;
    }

    struct itmap {
        uint size;
        mapping(address => IndexValue) data;
        KeyFlag []keys;
    }
 
    // key值的列表
    struct KeyFlag {
        address key;
        bool deleted;
    }
 
    // value
    struct IndexValue {
        uint KeyIndex;
        user value;
    }

    struct user{
        uint64 version;
        uint64 credit;
        bool agree;
    }
 
 
    // 插入数据
    function insert(address key, uint64 version, uint64 credit) internal returns(bool replaced) {
        uint keyIdx = credits.data[key].KeyIndex;
//        user storage value;
//        value.version=version;
//        value.credit=credit;
//        credits.data[key].value = value;
        credits.data[key].value.credit = credit;
        credits.data[key].value.version = version;
        if (keyIdx > 0) {
            return true;
        }else {
            keyIdx = credits.keys.length++;
            credits.data[key].KeyIndex = keyIdx+1;
            credits.keys[keyIdx].key = key;
            credits.size++;
            return false;
        }
    }
 
    // 删除数据(逻辑删除)
    function remove(address key) internal returns(bool) {
        uint keyIdx = credits.data[key].KeyIndex;
        if (keyIdx == 0) {
            return false;
        } else {
            delete credits.data[key]; //逻辑删除
            credits.keys[keyIdx-1].deleted = true;
            credits.size --;
            return true;
        }
    }
 
    // 获取数据
    function iterate_get(uint KeyIdx) internal returns(address key, uint64 version,uint64 credit,bool agree) {
        key = credits.keys[KeyIdx].key;
//        value = credits.data[key].value;
        version = credits.data[key].value.version;
        credit = credits.data[key].value.credit; 
        agree = credits.data[key].value.agree;
    }
 
    // 包含
    function iterate_contains(address key) internal returns(bool) {
        return credits.data[key].KeyIndex > 0;
    }
 
    // 获取下一个索引
    function iterate_next(uint _keyIndex) internal returns(uint r_keyIndex) {
 
        _keyIndex++;
        while(_keyIndex < credits.keys.length && credits.keys[_keyIndex].deleted) {
            _keyIndex++;
        }

        return _keyIndex;
    }
 
    // 开始遍历
    function iterate_start() internal returns(uint keyIndex) {
        keyIndex=iterate_next(uint(-1));
    }
 
    // 循环退出条件
    function iterate_valid(uint keyIndex) internal returns(bool) {
        return keyIndex < credits.keys.length;
    }

    function vote(bool voted) public{
        credits.data[msg.sender].value.agree = voted;
    }
    
    function judge(uint64 version) public returns(bool){
        uint64 agree;
        uint64 disagree;
        address key;
        uint64 ver;
        uint64 credit;
        bool userAgree;
        for(uint i = iterate_start();
        iterate_valid(i);
        i = iterate_next(i)){//没进来就执行下一步了
            (key,ver,credit,userAgree) = iterate_get(i);
            if(ver == version){
                if(userAgree){
                 agree+=credit;
                }else{
                 disagree+=credit;
                }
            }
        }
        return agree > disagree;
    }

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
    function update() public returns (uint64){
                uint64 a = 7;
                address user1 = 0x123;
                d_storage d = user1;
                a = d.sused(a);
                d_storage d2 = 0x456;   
                a=8;
                return a;
    }
}

