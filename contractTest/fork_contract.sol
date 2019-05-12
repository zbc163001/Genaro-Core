contract ForkContract {
    address user;
    mapping(address => uint) public credits;
    function ForkContract() public{
        user = 0x123;
        credits[user] = 10;
        user = 0x456;
        credits[user] = 20;
        user = 0x789;
        credits[user] = 30;

} 
    function Update() public view returns (uint64){
                uint64 a = 0;
                user = 0x123;
		d_storage d = user;
                a = d.sused(credits[user]);
                user = 0x456;
                d = user;
                a = d.sused(credits[user]);
		return a;
    }
}
// ----
