// SPDX-License-Identifier: UNLIMITCENSED
pragma solidity 0.8.7;

import "../../modules/ds-test/src/test.sol";

import "./utils/Mocks.sol";

import "./utils/Interfaces.sol";

import "../Proxy.sol";

import "../Deck.sol";

contract MetaAndMagicBaseTest is DSTest {
    MockMetaAndMagic meta;
    HeroesMock       heroes;
    ItemsMock        items;

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public virtual {

        heroes = HeroesMock(address(new Proxy(address(new HeroesMock()))));
        items  = ItemsMock(address(new Proxy(address(new ItemsMock()))));
        meta   = MockMetaAndMagic(address(new Proxy(address(new MockMetaAndMagic()))));

        meta.initialize(address(heroes), address(items));

        heroes.initialize(address(new HeroStats()), address(0));

        items.initialize(address(new AttackItemsStats()), address(new DefenseItemsStats()), address(new SpellItemsStats()), address(new BuffItemsStats()), address(0));

        items.setEntropy(uint256(keccak256(abi.encode("ENTROPY"))));
    }

    // Helper Functions
    function _getPackedItems(uint16[5] memory items_) internal pure returns(bytes10 packed) {
        packed = bytes10(abi.encodePacked(items_[0], items_[1], items_[2], items_[3], items_[4]));
    }

    function _addBoss() internal {
        meta.addBoss(address(1), 100e18, 20, 10000, 1000, 1000, 3, 0);
    }

}

contract AddBossTest is MetaAndMagicBaseTest {

    function test_AddBoss(address prizeToken, uint256 halfPrize, uint16 drops, uint16 hp_, uint16 atk_, uint16 mgk_, uint8 mod_, uint8 ele) public {
        meta.addBoss(prizeToken, halfPrize, drops, hp_, atk_, mgk_, mod_, ele);

        assertEq(meta.prizeTokens(2), prizeToken);
        assertEq(meta.prizeValues(2), halfPrize);

        (, uint16 d, uint16 top, uint128 hs,,)= meta.bosses(2);

        assertEq(d, drops);
        assertEq(hs, 0);
        assertEq(top, 0);
    }
    
}

contract ValidateItemTest is MetaAndMagicBaseTest {

    function test_validateItems_CorrectOrder() external {
        uint16[5] memory items_ = [uint16(1), 1, 1, 1, 1];

        // Valid lists
        items_ = _mintItems(342, 212, 111, 90, 3);
        meta.validateItems(items_);

        items_ = _mintItems(333, 120, 0, 0, 0);
        meta.validateItems(items_);

        items_ = _mintItems(300, 0, 0, 0, 0);
        meta.validateItems(items_);

        items_ = _mintItems(1, 0, 0, 0, 0);
        meta.validateItems(items_);
    }

    function test_validateItems_InvalidItems() external {
        uint16[5] memory items_ = [uint16(1), 1, 1, 1, 1];

        // Invalid Orders
        items_ = _mintItems(342, 212, 311, 0, 0);
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);

        items_ = _mintItems(343, 213, 313, 0, 3);
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);

        items_ = _mintItems(1, 200, 111, 0, 5);
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);

        items_ = _mintItems(0, 0, 0, 0, 0);
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);

        items_ = _mintItems(1000, 0, 444, 333, 141);
        items_ = [1000,1000,444,333,141];
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);

        items_ = _mintItems(999, 0, 555, 666, 181);
        items_ = [999,666,555,181,181];
        vm.expectRevert(bytes("invalid items"));
        meta.validateItems(items_);
    }

    function test_validateItems_NotOwner() external {
        uint16[5] memory items_ = [uint16(1), 1, 1, 1, 1];

        items_ = _mintItems(342, 212, 111, 90, 3);
        items_ = [342, 212, 111, 90, 4];
        vm.expectRevert(bytes("not item owner"));
        meta.validateItems(items_);
    }

    function _mintItems(uint16 one, uint16 two, uint16 three, uint16 four, uint16 five) internal returns (uint16[5] memory list) {
        if (one != 0) items.mint(address(this), one);
        if (two != 0) items.mint(address(this), two);
        if (three != 0) items.mint(address(this), three);
        if (four != 0) items.mint(address(this), four);
        if (five != 0) items.mint(address(this), five);
        list = [one, two, three, four, five];
    }

}

contract StakeTest is MetaAndMagicBaseTest {

    function testStake_success(uint16 heroId) external {
        if (heroId == 0) heroId++;

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);

        (address owner, uint16 lastBoss, uint32 highestScore) = meta.heroes(heroId);
        assertEq(owner, address(this));
        assertEq(lastBoss, 0);
        assertEq(highestScore, 0);
    }

    function testStake_notApproved(uint16 heroId) external {
        heroes.mint(address(this), heroId);

        vm.expectRevert(bytes("NOT_APPROVED"));
        meta.stake(heroId);

        heroes.approve(address(meta), heroId);
        meta.stake(heroId);
    }

    function _testStake_canUnstake(uint16 heroId) external {
        _addBoss();

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);

        // Not fighted so allowed to unstake
        meta.unstake(heroId);   
        (address owner, uint16 lastBoss, uint32 highestScore) = meta.heroes(heroId);
        assertEq(owner, address(0));
        assertEq(lastBoss, 0);
        assertEq(highestScore, 0);     
    }    

    function _testStake_failWithNotOwner(uint16 heroId) external {
        _addBoss();

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);

        // Not fighted so allowed to unstake
        vm.prank(address(2));
        vm.expectRevert("not owner");
        meta.unstake(heroId);   

        meta.unstake(heroId); 
        (address owner, uint16 lastBoss, uint32 highestScore) = meta.heroes(heroId);
        assertEq(owner, address(0));
        assertEq(lastBoss, 0);
        assertEq(highestScore, 0);     
    }    

    function _testStake_failIfFought(uint16 heroId) external {
        _addBoss();

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);

        uint16[5] memory list = items.mintFive(address(this), 5, 4, 3, 2, 1);
        bytes10 itm = _getPackedItems(list);

        meta.fight(heroId, itm);
        
        // Not fighted so allowed to unstake
        vm.expectRevert("alredy entered");
        meta.unstake(heroId);   

        _addBoss();

        meta.unstake(heroId); 
        (address owner, uint16 lastBoss, uint32 highestScore) = meta.heroes(heroId);
        assertEq(owner, address(0));
        assertEq(lastBoss, 0);
        assertEq(highestScore, 0);     
    }    

}

contract FightTest is MetaAndMagicBaseTest {

    uint256 boss   = 2;
    uint256 heroId = 1;

    uint16[5] list; 
    uint16[5] list2; 

    bytes10 itm;
    bytes10 itm2;

    function setUp() public override {
        super.setUp();
        _addBoss();

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);
        list = items.mintFive(address(this), 5, 4, 3, 2, 1);
        itm = _getPackedItems(list);

        list2 = items.mintFive(address(this), 10, 9, 8, 7, 6);
        itm2 = _getPackedItems(list2);
    }

    function test_fight_success() external {
        uint256 nextScore = 10;
        meta.setNextScore(nextScore);

        bytes32 id = meta.fight(heroId, itm);

        (uint16 hero, uint16 boss_, bytes10 items_, uint32 start, uint32 count, bool s_claimed ) = meta.fights(id);

        assertEq(hero, heroId);
        assertEq(boss_, boss);
        assertEq(items_ , itm);
        assertEq(start, 1);
        assertEq(count, 10);
        
        assertTrue(!s_claimed);

        uint256 score = meta.getScore(boss, heroId, itm);

        (,,uint16 topS,uint128 hs,uint256 entries, uint256 winningIndex) = meta.bosses(boss);
        
        assertEq(score, hs);
        assertEq(score, nextScore);
        assertEq(topS, 1);
        assertEq(entries, nextScore);
        assertEq(winningIndex, 0);
    }
    
    function test_fight_replaceHeroHighScore() external {
        uint256 nextScore = 10;
        meta.setNextScore(nextScore);

        bytes32 id = meta.fight(heroId, itm);

        ( , , , uint32 start, uint32 count, ) = meta.fights(id);

        assertEq(start, 1);
        assertEq(count, 10);

        uint256 secondScore = 14;
        meta.setNextScore(secondScore);

        bytes32 id2 = meta.fight(heroId, itm2);

        ( , , , start, count,) = meta.fights(id2);

        assertEq(start, 11);
        assertEq(count, 4);
 
        (,, uint256 top ,uint256 hs,uint256 entries,  uint256 winningIndex) = meta.bosses(boss);
        assertEq(hs, secondScore);
        assertEq(top, 1);
        assertEq(entries, 14);
        assertEq(winningIndex, 0);
    }

    function test_fight_topScores() external {
        uint256 nextScore = 10;
        meta.setNextScore(nextScore);

        uint256 tops = 25;
        for (uint16 i = 2; i < tops; i++) {
            // mint hero
            heroes.mint(address(this), i);
            heroes.approve(address(meta), i); 

            uint16[5] memory deck = items.mintFive(address(this), i * 100 + i, i * 90 + i, i * 80 + i, i * 70 + i, i * 60+ i);
            bytes10 d = _getPackedItems(deck);
            
            meta.stake(i);   
            meta.fight(i, d);
        }

        (,, uint256 top ,uint256 hs,uint256 entries,  uint256 winningIndex) = meta.bosses(boss);

        assertEq(hs, 10);
        assertEq(top, tops - 2);
        assertEq(entries, (tops - 2) * 10);
        assertEq(winningIndex, 0);
    }

    function test_fight_replaceBossHighScore() external {

        uint256 tops = 25;
        for (uint16 i = 2; i < tops; i++) {
            meta.setNextScore(i * 100);
            // mint hero
            heroes.mint(address(this), i);
            heroes.approve(address(meta), i); 

            uint16[5] memory deck = items.mintFive(address(this), i * 100 + i, i * 90 + i, i * 80 + i, i * 70 + i, i * 60+ i);
            bytes10 d = _getPackedItems(deck);
            
            meta.stake(i);   
            meta.fight(i, d);
        }

        (,, uint256 top ,uint256 hs,,uint256 winningIndex) = meta.bosses(boss);
        assertEq(hs, 24 * 100);
        assertEq(top, 1);
        assertEq(winningIndex, 0);
    }

    function test_fight_failTwice() external {
        meta.fight(heroId, itm);

        vm.expectRevert(bytes("already fought"));
        meta.fight(heroId, itm);
    }

}

contract ClaimBossDropTest is MetaAndMagicBaseTest {
     uint256 boss   = 2;
    uint256 heroId = 1;

    uint16[5] list; 
    uint16[5] list2; 

    bytes10 itm;
    bytes10 itm2;

    function setUp() public override {
        super.setUp();
        _addBoss();

        heroes.mint(address(this), heroId);
        heroes.approve(address(meta), heroId);

        meta.stake(heroId);
        list = items.mintFive(address(this), 5, 4, 3, 2, 1);
        itm = _getPackedItems(list);

        list2 = items.mintFive(address(this), 10, 9, 8, 7, 6);
        itm2 = _getPackedItems(list2);

        uint256 nextScore = 10;
        meta.setNextScore(nextScore);

        meta.fight(heroId, itm);
    }

    function test_claimBossDrop_success() external {
        uint256 itemId = meta.getBossDrop(heroId, 2, itm);

        assertEq(items.ownerOf(itemId), address(this));

        // Check all items are burned
        for (uint256 i = 0; i < list.length; i++) {
            assertEq(items.ownerOf(list[i]), address(0));
        }
    }

    function test_claimBossDrop_failWithClaimTwice() external {
        uint256 itemId = meta.getBossDrop(heroId, 2, itm);

        assertEq(items.ownerOf(itemId), address(this));

        // Check all items are burned
        for (uint256 i = 0; i < list.length; i++) {
            assertEq(items.ownerOf(list[i]), address(0));
        }

        vm.expectRevert("not owner");
        meta.getBossDrop(heroId, 2, itm);
    }
}

contract GetStatsTest is MetaAndMagicBaseTest {

    function setUp() public override {
        super.setUp();
    }

    function test_get_attributes() public {
        heroes.setAttributes(1, [uint256(5),5,1,5,4,15]);

        (bytes32 s1, bytes32 s2) = heroes.getStats(1);

        assertTrue(s1 != bytes32(0));
        assertTrue(s2 != bytes32(0));

        //Level (V) atts
        assertEq(meta.get(s1,0,0), 500); // hp
        assertEq(meta.get(s1,1,0), 0);   // atk
        assertEq(meta.get(s1,2,0), 0);   //mgk
        assertEq(meta.get(s1,3,0), 0);   // mgk_res
        assertEq(meta.get(s1,4,0), 0);   // mgk_pem
        assertEq(meta.get(s1,5,0), 0);   // phy_res
        assertEq(meta.get(s1,6,0), 0);   // phy_pen

        // Class (Mage) atts
        assertEq(meta.get(s1,0,1), 1000); // hp
        assertEq(meta.get(s1,1,1), 0);   // atk
        assertEq(meta.get(s1,2,1), 1000);   //mgk
        assertEq(meta.get(s1,3,1), 1);   // mgk_res
        assertEq(meta.get(s1,4,1), 1);   // mgk_pem
        assertEq(meta.get(s1,5,1), 0);   // phy_res
        assertEq(meta.get(s1,6,1), 0);   // phy_pen

        // Rank (novice) atts
        assertEq(meta.get(s1,0,2), 99); // hp
        assertEq(meta.get(s1,1,2), 0);   // atk
        assertEq(meta.get(s1,2,2), 0);   //mgk
        assertEq(meta.get(s1,3,2), 0);   // mgk_res
        assertEq(meta.get(s1,4,2), 0);   // mgk_pem
        assertEq(meta.get(s1,5,2), 0);   // phy_res
        assertEq(meta.get(s1,6,2), 0);   // phy_pen

        // Rarity (epic) atts
        assertEq(meta.get(s2,0,0), 500); // hp
        assertEq(meta.get(s2,1,0), 500);   // atk
        assertEq(meta.get(s2,2,0), 500);   //mgk
        assertEq(meta.get(s2,3,0), 1);   // mgk_res
        assertEq(meta.get(s2,4,0), 0);   // mgk_pem
        assertEq(meta.get(s2,5,0), 1);   // phy_res
        assertEq(meta.get(s2,6,0), 1);   // phy_pen

        // Pet (Sphinx) atts
        assertEq(meta.get(s2,0,1), 4000); // hp
        assertEq(meta.get(s2,1,1), 4000); // atk
        assertEq(meta.get(s2,2,1), 4000);   //mgk
        assertEq(meta.get(s2,3,1), 1);   // mgk_res
        assertEq(meta.get(s2,4,1), 1);   // mgk_pem
        assertEq(meta.get(s2,5,1), 1);   // phy_res
        assertEq(meta.get(s2,6,1), 1);   // phy_pen

        // Item (elixir) atts
        assertEq(meta.get(s2,0,2), 1500); // hp
        assertEq(meta.get(s2,1,2), 0);    // atk
        assertEq(meta.get(s2,2,2), 0);    //mgk
        assertEq(meta.get(s2,3,2), 0);    // mgk_res
        assertEq(meta.get(s2,4,2), 0);    // mgk_pem
        assertEq(meta.get(s2,5,2), 1);    // phy_res
        assertEq(meta.get(s2,6,2), 0);    // phy_pen
    }
    
}

contract CalculateScoreTest is MetaAndMagicBaseTest {

    uint256 heroId = 1;

    // Boss stats
    uint16 bossHp;
    uint16 bossAtk;
    uint16 bossMgk;
    uint16 bossMod;

    // Hero Stats
    uint16 heroHp;
    uint16 heroAtk;
    uint16 heroMgk;
    uint8  heroMod;

    int256 expectedBossHp;
    int256 expectedPlayerHp;

    HeroesDeck deck;
    ItemsDeck  itemsDeck;

    function setUp() public override {
        super.setUp();

        deck = new HeroesDeck();
        itemsDeck = new ItemsDeck();
    }

    // function test_fightScore_1() external {
        
    //     heroes.setAttributes(1, [uint256(5),2,5,1,4,15]);

    //     // Attack
    //     items.setAttributes(1,  [uint256(4),4,3,5,4,0]);

    //     // Defense
    //     items.setAttributes(2,  [uint256(3),4,3,4,43,0]);

    //     // Spell
    //     items.setAttributes(3,  [uint256(2),3,3,3,5,0]);

    //     // Buff
    //     items.setAttributes(4,  [uint256(1),1,3,5,1,1]);

    //     // Set Boss 1
    //     bossHp  = 2500;
    //     bossAtk = 1500;
    //     bossMgk = 3500;
    //     bossMod = 6;

    //     bytes8 bossStats = bytes8(abi.encodePacked(bossHp, bossAtk, bossMgk, bossMod));

    //     uint256 s = meta.getScore(bossStats, 1, _getPackedItems([uint16(4),3,2,1,0]));

    //     emit log_named_uint("score", s);
    // }

    // function test_fightScore_2() external {
        
    //     heroes.setAttributes(1, [uint256(1),3,1,2,2,8]);

    //     // Attack
    //     items.setAttributes(1,  [uint256(3),3,2,3,2,1]);

    //     // Defense
    //     items.setAttributes(2,  [uint256(2),2,2,1,1,2]);

    //     // Spell
    //     items.setAttributes(3,  [uint256(4),4,2,4,4,3]);

    //     // Buff
    //     items.setAttributes(4,  [uint256(4),3,1,3,1,1]);

    //     // Set Boss 1
    //     bossHp  = 1000;
    //     bossAtk = 2000;
    //     bossMgk = 0;
    //     bossMod = 0;

    //     bytes8 bossStats = bytes8(abi.encodePacked(bossHp, bossAtk, bossMgk, bossMod));

    //     uint256 s = meta.getScore(bossStats, 1, _getPackedItems([uint16(4),3,2,1,0]));
    // }  

    function test_fightScore_3() external {
        
        heroes.setAttributes(1, [uint256(5),3,2,1,4,15]);

        // Set Boss 1
        bossHp  = 1000;
        bossAtk = 2000;
        bossMgk = 0;
        bossMod = 0;

        bytes8 bossStats = bytes8(abi.encodePacked(bossHp, bossAtk, bossMgk, bossMod));

        uint256 s = meta.getScore(bossStats, 1, bytes10(""));
        emit log_named_uint("socre", s);
        fail();
    }

    function test_scoreSimulation_boss1() external {
        uint256 runs = 10;
        for (uint256 j = 0; j < runs; j++) {
            uint256 entropy = uint256(keccak256(abi.encode(j, "ENTROPY")));
            emit log("---------------------------------------------------");
            emit log("Boss: 1");
            emit log("        | hp:      1000");
            emit log("        | phy_dmg: 2000");
            emit log("        | mgk_dmg: 0");
            emit log("        | element: none");

            emit log("");
            emit log("Hero Attributes:");

            // Build hero 
            heroes.setEntropy(uint256(keccak256(abi.encode(entropy, "HEROES")))); 
            uint256[6] memory t = heroes.getTraits(1);
            string[6] memory n = deck.getTraitsNames(t);
            emit log_named_string("        | Level  ", n[0]);
            emit log_named_string("        | Class  ", n[1]);
            emit log_named_string("        | Rank   ", n[2]);
            emit log_named_string("        | Rarity ", n[3]);
            emit log_named_string("        | Pet    ", n[4]);
            emit log_named_string("        | Item   ", n[5]);

            emit log("");

            items.setEntropy(uint256(keccak256(abi.encode(entropy, "ITEMS"))));

            // get a few items
            uint num_items = _getRanged(entropy, 0, 6, "num items");
            uint16[5] memory items_ = [uint16(0),0,0,0,0];
            for (uint16 index = 1; index < num_items; index++) {
                items_[index - 1] = index;
                t = items.getTraits(index);
                string[6] memory n = itemsDeck.getTraitsNames(t);
                emit log_named_uint("Item ", index);
                emit log_named_string("        | Level                   ", n[0]);
                emit log_named_string("        | Kind                    ", n[1]);
                emit log_named_string("        | Material/Energy/Vintage ", n[2]);
                emit log_named_string("        | Rarity                  ", n[3]);
                emit log_named_string("        | Quality                 ", n[4]);
                emit log_named_string("        | Element / Potency       ", n[5]);
                emit log("");
            }

            // Set Boss 1
            bossHp  = 1000;
            bossAtk = 2000;
            bossMgk = 0;
            bossMod = 0;

            bytes8 bossStats = bytes8(abi.encodePacked(bossHp, bossAtk, bossMgk, bossMod));

            MetaAndMagic.Combat memory c = meta.getCombat(bossStats, 1, _getPackedItems(items_));
            // uint256 score = meta.getScore(bossStats, 1, _getPackedItems(items_));
            emit log("Combat Numbers: ");
            emit log_named_uint("   | Total hero HP", c.hp);
            emit log_named_uint("   | Total hero phy_dmg", c.phyDmg);
            emit log_named_uint("   | Total hero mgk_dmg", c.mgkDmg);
            emit log("");
            emit log("    Stacked variables (1e12 == 1)");
            emit log_named_uint("   | Hero stacked phy_res", c.phyRes);
            emit log_named_uint("   | Hero stacked mgk_res", c.mgkRes);
            emit log_named_uint("   | Boss stacked phy_res", c.bossPhyRes);
            emit log_named_uint("   | Boss stacked mgk_res", c.bossMgkRes);
            emit log("");

            (uint256 heroAttack, uint256 bossPhny) = meta.getRes(c, bossStats);
            emit log_named_uint("Hero Attack", heroAttack);
            emit log_named_uint("Boss Attack", bossPhny);

            emit log("");
            emit log_named_uint("Final Result", meta.getResult(c, bossStats));
        }

    }

    function _getRanged(uint256 entropy, uint256 start, uint256 end, string memory salt) internal pure returns(uint256 rdn) {
        rdn = uint256(keccak256(abi.encodePacked(entropy, salt))) % (end - start) + start;
    }

}