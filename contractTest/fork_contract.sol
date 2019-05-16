contract ForkContract {
    address user;
    mapping(address => uint) public credits;
    function forkContract() payable {
        user = 0x123;
        credits[user] = 10;
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

