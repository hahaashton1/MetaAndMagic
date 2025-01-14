// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface StatsLike {
    function getStats(uint256[6] calldata attributes) external view returns (bytes10[6] memory stats); 
}

contract AttackItemsStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        if (atts[0] > 10) return specialTraits(atts[0]);

        stats = [level(atts[0]), kind(atts[1]), material(atts[2]), rarity(atts[3]), quality(atts[4]), bytes10(uint80(atts[5]))];
    }

    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        // Attack
        if (id == 1) (hp, atk, mgk, mod) = (0, 99,0,0); // I
        if (id == 2) (hp, atk, mgk, mod) = (0,198,0,0); // II
        if (id == 3) (hp, atk, mgk, mod) = (0,297,0,0); // III
        if (id == 4) (hp, atk, mgk, mod) = (0,396,0,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (0,495,0,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (0,994,0,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function kind(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Attack
        if (id == 1) (hp, atk, mgk, mod) = (0,500,0,0);   // Dagger
        if (id == 2) (hp, atk, mgk, mod) = (0,1000,0,0);   // Sword
        if (id == 3) (hp, atk, mgk, mod) = (0,1500,0,8);  // Hammer
        if (id == 4) (hp, atk, mgk, mod) = (0,2000,500,10); // Spear
        if (id == 5) (hp, atk, mgk, mod) = (0,2500,1000,2);  // Mace
        if (id == 6) (hp, atk, mgk, mod) = (0,3000,1500,10); // Staff

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function material(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Attack
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);  // Wood
        if (id == 2) (hp, atk, mgk, mod) = (0,0,98,0); // Iron 
        if (id == 3) (hp, atk, mgk, mod) = (0,0,197,0); // Bronze 
        if (id == 4) (hp, atk, mgk, mod) = (0,0,296,0); // Silver
        if (id == 5) (hp, atk, mgk, mod) = (0,0,395,0); // Gold 
        if (id == 6) (hp, atk, mgk, mod) = (0,0,494,0); // Mythril

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);   // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);   // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);   // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);  // Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13);  // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15);  // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function quality(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);    // Normal
        if (id == 2) (hp, atk, mgk, mod) = (0,100,0,0);  // Good
        if (id == 3) (hp, atk, mgk, mod) = (0,200,0,0);  // Very Good
        if (id == 4) (hp, atk, mgk, mod) = (0,300,0,0);  // Fine
        if (id == 5) (hp, atk, mgk, mod) = (0,400,0,0);  // Superfine
        if (id == 6) (hp, atk, mgk, mod) = (0,500,0,0);  // Excellent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function specialTraits(uint256 id) public pure returns (bytes10[6] memory stats) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 11) (hp, atk, mgk, mod) = (   0,   3750, 1500, 10); // Excalibur of King Arthur
        if (id == 22) (hp, atk, mgk, mod) = ( 5000,  4500, 2250, 10); // Mjolnir of Thor
        if (id == 33) (hp, atk, mgk, mod) = ( 8258,     0,   0,  8); // Headband of Wukong
        if (id == 44) (hp, atk, mgk, mod) = (11250,     0,   0,  8); // Achilleus armor
        if (id == 55) (hp, atk, mgk, mod) = (    0,  1500, 3750, 10); // Avada Kedavra
        if (id == 66) (hp, atk, mgk, mod) = (    0,  2250, 4500, 10); // Kamehameha
        if (id == 77) (hp, atk, mgk, mod) = ( 5000,  1000, 1000, 15); // Urim and Thummim
        if (id == 88) (hp, atk, mgk, mod) = ( 6000,  1000, 1000, 15); // Philosphers stone

        bytes10 packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));

        stats = [packed, bytes10(0), bytes10(0), bytes10(0), bytes10(0), bytes10(0)];
    }
}

contract DefenseItemsStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        if (atts[0] > 10) return specialTraits(atts[0]);

        stats = [level(atts[0]), kind(atts[1]), material(atts[2]), rarity(atts[3]), quality(atts[4]), bytes10(uint80(atts[5]))];
    }

    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Defense
        if (id == 1) (hp, atk, mgk, mod) = ( 99,0,0,0);  // I
        if (id == 2) (hp, atk, mgk, mod) = (198,0,0,0);  // II
        if (id == 3) (hp, atk, mgk, mod) = (297,0,0,0);  // III
        if (id == 4) (hp, atk, mgk, mod) = (396,0,0,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (495,0,0,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (994,0,0,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function kind(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Defense
        if (id == 1) (hp, atk, mgk, mod) = (1000,0,0,0);   // Leather
        if (id == 2) (hp, atk, mgk, mod) = (2000,0,0,0);   // Split MailK
        if (id == 3) (hp, atk, mgk, mod) = (3000,0,0,4);   // Chain Mail
        if (id == 4) (hp, atk, mgk, mod) = (4000,0,0,5);  // Scale Mail
        if (id == 5) (hp, atk, mgk, mod) = (5000,0,0,1);  // Half Plate
        if (id == 6) (hp, atk, mgk, mod) = (10000,0,0,5); // Full Plate

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function material(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Defense
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);   // Wood
        if (id == 2) (hp, atk, mgk, mod) = (98,0,0,0); // Iron
        if (id == 3) (hp, atk, mgk, mod) = (197,0,0,0); // Bronze
        if (id == 4) (hp, atk, mgk, mod) = (296,0,0,1); // Silver
        if (id == 5) (hp, atk, mgk, mod) = (395,0,0,4); // Gold
        if (id == 6) (hp, atk, mgk, mod) = (494,0,0,5); // Mythril

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);   // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);   // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);   // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);  // Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13);  // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15);  // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function quality(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Defense
        if (id == 1)  (hp, atk, mgk, mod) = (0,0,0,0);    // Normal
        if (id == 2)  (hp, atk, mgk, mod) = (98,0,0,0);  // Good
        if (id == 3)  (hp, atk, mgk, mod) = (197,0,0,0);  // Very Good
        if (id == 4)  (hp, atk, mgk, mod) = (296,0,0,1);  //  Fine
        if (id == 5)  (hp, atk, mgk, mod) = (395,0,0,4);  //  Superfine
        if (id == 6)  (hp, atk, mgk, mod) = (494,0,0,5);  //  Excellent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function specialTraits(uint256 id) public pure returns (bytes10[6] memory stats) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 11) (hp, atk, mgk, mod) = (   0,   3750, 1500, 10); // Excalibur of King Arthur
        if (id == 22) (hp, atk, mgk, mod) = ( 5000,  4500, 2250, 10); // Mjolnir of Thor
        if (id == 33) (hp, atk, mgk, mod) = ( 8258,     0,   0,  8); // Headband of Wukong
        if (id == 44) (hp, atk, mgk, mod) = (11250,     0,   0,  8); // Achilleus armor
        if (id == 55) (hp, atk, mgk, mod) = (    0,  1500, 3750, 10); // Avada Kedavra
        if (id == 66) (hp, atk, mgk, mod) = (    0,  2250, 4500, 10); // Kamehameha
        if (id == 77) (hp, atk, mgk, mod) = ( 5000,  1000, 1000, 15); // Urim and Thummim
        if (id == 88) (hp, atk, mgk, mod) = ( 6000,  1000, 1000, 15); // Philosphers stone

        bytes10 packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));

        stats = [packed, bytes10(0), bytes10(0), bytes10(0), bytes10(0), bytes10(0)];
    }
}

contract SpellItemsStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        if (atts[0] > 10) return specialTraits(atts[0]);
        
        stats = [level(atts[0]), kind(atts[1]), energy(atts[2]), rarity(atts[3]), quality(atts[4]), bytes10(uint80(atts[5]))];
    }

    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Spell
        if (id == 1) (hp, atk, mgk, mod) = (0,0, 99,0); // I
        if (id == 2) (hp, atk, mgk, mod) = (0,0,198,0); // II
        if (id == 3) (hp, atk, mgk, mod) = (0,0,297,0); // III
        if (id == 4) (hp, atk, mgk, mod) = (0,0,396,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (0,0,495,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (0,0,994,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function kind(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Spell 
        if (id == 1) (hp, atk, mgk, mod) = (0,0,500,0);      // Force
        if (id == 2) (hp, atk, mgk, mod) = (0,0,1000,0);     // Implosion
        if (id == 3) (hp, atk, mgk, mod) = (0,0,1500,2);     // Explosion
        if (id == 4) (hp, atk, mgk, mod) = (500,0,2000,9);   // Antimatter
        if (id == 5) (hp, atk, mgk, mod) = (1000,0,2500,8);  // Supernova
        if (id == 6) (hp, atk, mgk, mod) = (1500,0,3000,10); // Ultimatum

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function energy(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);   // Kinectic
        if (id == 2) (hp, atk, mgk, mod) = (0,0,98,0); // Potential
        if (id == 3) (hp, atk, mgk, mod) = (0,0,197,0); // Electrical
        if (id == 4) (hp, atk, mgk, mod) = (0,0,296,0); // Nuclear
        if (id == 5) (hp, atk, mgk, mod) = (0,0,395,0); // Gravitational
        if (id == 6) (hp, atk, mgk, mod) = (0,0,494,0); // Cosmic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);   // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);   // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);   // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);  // Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13);  // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15);  // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function quality(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Spell
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);   // Normal
        if (id == 2) (hp, atk, mgk, mod) = (0,98,0,0); // Good
        if (id == 3) (hp, atk, mgk, mod) = (0,197,0,0); // Very Good
        if (id == 4) (hp, atk, mgk, mod) = (0,296,0,0); // Fine
        if (id == 5) (hp, atk, mgk, mod) = (0,395,0,0); // Superfime
        if (id == 6) (hp, atk, mgk, mod) = (0,494,0,0); // Excellent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function specialTraits(uint256 id) public pure returns (bytes10[6] memory stats) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 11) (hp, atk, mgk, mod) = (   0,   3750, 1500, 10); // Excalibur of King Arthur
        if (id == 22) (hp, atk, mgk, mod) = ( 5000,  4500, 2250, 10); // Mjolnir of Thor
        if (id == 33) (hp, atk, mgk, mod) = ( 8258,     0,   0,  8); // Headband of Wukong
        if (id == 44) (hp, atk, mgk, mod) = (11250,     0,   0,  8); // Achilleus armor
        if (id == 55) (hp, atk, mgk, mod) = (    0,  1500, 3750, 10); // Avada Kedavra
        if (id == 66) (hp, atk, mgk, mod) = (    0,  2250, 4500, 10); // Kamehameha
        if (id == 77) (hp, atk, mgk, mod) = ( 5000,  1000, 1000, 15); // Urim and Thummim
        if (id == 88) (hp, atk, mgk, mod) = ( 6000,  1000, 1000, 15); // Philosphers stone

        bytes10 packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));

        stats = [packed, bytes10(0), bytes10(0), bytes10(0), bytes10(0), bytes10(0)];
    }
}

contract BuffItemsStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        if (atts[0] > 10) return specialTraits(atts[0]);
        stats = [level(atts[0]), kind(atts[1]), vintage(atts[2]), rarity(atts[3]), quality(atts[4]), potency(atts[5])];
    }

    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Buff
        if (id == 1) (hp, atk, mgk, mod) = ( 99,0,0,0); // I
        if (id == 2) (hp, atk, mgk, mod) = (198,0,0,0); // II
        if (id == 3) (hp, atk, mgk, mod) = (297,0,0,0); // III
        if (id == 4) (hp, atk, mgk, mod) = (396,0,0,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (495,0,0,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (994,0,0,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function kind(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Buff
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);  // Potion
        if (id == 2) (hp, atk, mgk, mod) = (1000,0,0,0); // Ether
        if (id == 3) (hp, atk, mgk, mod) = (1500,0,0,4); // Elixir
        if (id == 4) (hp, atk, mgk, mod) = (2000,0,0,1); // Nectar
        if (id == 5) (hp, atk, mgk, mod) = (2500,0,0,5); // Ambrosia
        if (id == 6) (hp, atk, mgk, mod) = (3000,0,0,5); // Cornucopia

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);      // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);      // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);    // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);   // Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13); // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15); // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function quality(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Buff
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);    // Normal
        if (id == 2) (hp, atk, mgk, mod) = (0,98,0,0); // Good
        if (id == 3) (hp, atk, mgk, mod) = (0,197,0,0); // Very Good
        if (id == 4) (hp, atk, mgk, mod) = (0,296,0,0); // Fine
        if (id == 5) (hp, atk, mgk, mod) = (0,395,0,0); // Superfime
        if (id == 6) (hp, atk, mgk, mod) = (0,494,0,0); // Excellent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function vintage(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Buff - Applicable both to Element and Vintage stats
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);      // New
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);      // Annum 
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);    // Decade
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);   // Century
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13); // Millenium 
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15); // Beginning of Time

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function potency(uint256 potencyId) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Buff - Applicable both to Element and Vintage stats
        if (potencyId == 1) (hp, atk, mgk, mod) = (0,0,0,0);   // None
        if (potencyId == 2) (hp, atk, mgk, mod) = (0,0,98,0); // Weak
        if (potencyId == 3) (hp, atk, mgk, mod) = (0,0,197,0); // Mild
        if (potencyId == 4) (hp, atk, mgk, mod) = (0,0,296,0); // Regular
        if (potencyId == 5) (hp, atk, mgk, mod) = (0,0,395,0); // Strong
        if (potencyId == 6) (hp, atk, mgk, mod) = (0,0,494,0); // Potent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function specialTraits(uint256 id) public pure returns (bytes10[6] memory stats) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 11) (hp, atk, mgk, mod) = (   0,   3750, 1500, 10); // Excalibur of King Arthur
        if (id == 22) (hp, atk, mgk, mod) = ( 5000,  4500, 2250, 10); // Mjolnir of Thor
        if (id == 33) (hp, atk, mgk, mod) = ( 8258,     0,   0,  8); // Headband of Wukong
        if (id == 44) (hp, atk, mgk, mod) = (11250,     0,   0,  8); // Achilleus armor
        if (id == 55) (hp, atk, mgk, mod) = (    0,  1500, 3750, 10); // Avada Kedavra
        if (id == 66) (hp, atk, mgk, mod) = (    0,  2250, 4500, 10); // Kamehameha
        if (id == 77) (hp, atk, mgk, mod) = ( 5000,  1000, 1000, 15); // Urim and Thummim
        if (id == 88) (hp, atk, mgk, mod) = ( 6000,  1000, 1000, 15); // Philosphers stone

        bytes10 packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));

        stats = [packed, bytes10(0), bytes10(0), bytes10(0), bytes10(0), bytes10(0)];
    }
}

contract BossDropsStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        stats = [level(atts[0]), kind(atts[1]), rarity(atts[2]), quality(atts[3]), bytes10(0), bytes10(uint80(atts[5]))];
    }

    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Spell
        if (id == 1) (hp, atk, mgk, mod) = (99,0,0,0); // I
        if (id == 2) (hp, atk, mgk, mod) = (198,0,0,0); // II
        if (id == 3) (hp, atk, mgk, mod) = (297,0,0,0); // III
        if (id == 4) (hp, atk, mgk, mod) = (396,0,0,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (495,0,0,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (994,0,0,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function kind(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
 
        // Todo fill according to latest tokenomics
        if (id == 11)  (hp, atk, mgk, mod) = (0,1500,1500,0);      // Dogemons Tail
        if (id == 12)  (hp, atk, mgk, mod) = (5000,0,0,0);     // Lunar Rings
        if (id == 13)  (hp, atk, mgk, mod) = (0,2000,2000,2);     // Etherhead
        if (id == 14)  (hp, atk, mgk, mod) = (10000,0,0,9);   // Axie Wings
        if (id == 15)  (hp, atk, mgk, mod) = (0,3000,3000,8);  // Circulonimbus
        if (id == 16)  (hp, atk, mgk, mod) = (15000,0,0,10); // Vitalik's Horn
        if (id == 17)  (hp, atk, mgk, mod) = (0,4000,4000,10); // Sand Sacle
        if (id == 18)  (hp, atk, mgk, mod) = (20000,0,0,10); // Lunar crystal
        if (id == 19)  (hp, atk, mgk, mod) = (0,5000,5000,10); // Polybeast Shards

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0);   // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4);   // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5);   // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);  // Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13);  // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15);  // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function quality(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        
        // Spell
        if (id == 1) (hp, atk, mgk, mod) = (0,0,0,0);   // Normal
        if (id == 2) (hp, atk, mgk, mod) = (0,100,0,0); // Good
        if (id == 3) (hp, atk, mgk, mod) = (0,200,0,0); // Very Good
        if (id == 4) (hp, atk, mgk, mod) = (0,300,0,0); // Fine
        if (id == 5) (hp, atk, mgk, mod) = (0,400,0,0); // Superfine
        if (id == 6) (hp, atk, mgk, mod) = (0,500,0,0); // Excellent

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }
}

contract HeroStats is StatsLike {

    function getStats(uint256[6] calldata atts) public pure override returns (bytes10[6] memory stats) {
        if (atts[0] > 10) return specialTraits(atts[0]);
        
        stats = [level(atts[0]), class(atts[1]), rank(atts[2]), rarity(atts[3]), pet(atts[4]), item(atts[5])];
    }

     // HERO STATS
    
    function level(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 1) (hp, atk, mgk, mod) = (99,0,0,0); // I
        if (id == 2) (hp, atk, mgk, mod) = (198,0,0,0); // II
        if (id == 3) (hp, atk, mgk, mod) = (297,0,0,0); // III
        if (id == 4) (hp, atk, mgk, mod) = (396,0,0,0); // IV
        if (id == 5) (hp, atk, mgk, mod) = (495,0,0,0); // V
        if (id == 6) (hp, atk, mgk, mod) = (994,0,0,0); // X

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function class(uint256 classId) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (classId == 1) (hp, atk, mgk, mod) = (1000,1000,   0,12); // Warrior
        if (classId == 2) (hp, atk, mgk, mod) = (500 , 500,1000,10); // Marksman 
        if (classId == 3) (hp, atk, mgk, mod) = (500 ,1000, 500,6);  // Assassin
        if (classId == 4) (hp, atk, mgk, mod) = (1500,   0, 500,5);  // Monk 
        if (classId == 5) (hp, atk, mgk, mod) = (1000,   0,1000,3);  // Mage
        if (classId == 6) (hp, atk, mgk, mod) = (2000,2000,   0,9);  // Zombie
        if (classId == 7) (hp, atk, mgk, mod) = (4000,2000,2000,15); // God
        if (classId == 8) (hp, atk, mgk, mod) = (5000,3000,3000,15); // Oracle

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function pet(uint256 petId) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (petId == 1) (hp, atk, mgk, mod) = (0,0,0,0);           // None
        if (petId == 2) (hp, atk, mgk, mod) = (999,999,999,0);     // Fairy
        if (petId == 3) (hp, atk, mgk, mod) = (1998,1998,1998,5);  // Kitsune
        if (petId == 4) (hp, atk, mgk, mod) = (2997,2997,2997,10); // Unicorn
        if (petId == 5) (hp, atk, mgk, mod) = (3996,3996,3996,15); // Sphinx
        if (petId == 6) (hp, atk, mgk, mod) = (4995,4995,4995,15); // Dragon

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rank(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);
        //todo adjust this
        if (id == 1) (hp, atk, mgk, mod) = (99, 0,0,0);  // novice
        if (id == 2) (hp, atk, mgk, mod) = (198,0,0,4);  // beginner
        if (id == 3) (hp, atk, mgk, mod) = (297,0,0,1); // intermediate
        if (id == 4) (hp, atk, mgk, mod) = (396,0,0,5); // advanced
        if (id == 5) (hp, atk, mgk, mod) = (495,0,0,5); // expert
        if (id == 6) (hp, atk, mgk, mod) = (994,0,0,5); // master

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function item(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 1)  (hp, atk, mgk, mod) = (   0, 500,   0, 0); //dagger
        if (id == 2)  (hp, atk, mgk, mod) = (   0,1000,   0, 0); //sword
        if (id == 3)  (hp, atk, mgk, mod) = (   0,1500,   0, 8); // hammer
        if (id == 4)  (hp, atk, mgk, mod) = (   0,2000, 500,1); //spear
        if (id == 5)  (hp, atk, mgk, mod) = (   0,2500,1000, 2); // mace
        if (id == 6)  (hp, atk, mgk, mod) = (   0,3000,1500,1); //staff
        if (id == 7)  (hp, atk, mgk, mod) = (   0,   0, 500, 0); // force
        if (id == 8)  (hp, atk, mgk, mod) = (   0,   0,1000, 0); //implosion
        if (id == 9)  (hp, atk, mgk, mod) = (   0,   0,1500, 2); // explosion
        if (id == 10) (hp, atk, mgk, mod) = (   0, 500,2000,1); //antimatter
        if (id == 11) (hp, atk, mgk, mod) = (   0,1000,2500, 8); // supernova
        if (id == 12) (hp, atk, mgk, mod) = (   0,1500,3000,1); //ultimatum
        if (id == 13) (hp, atk, mgk, mod) = ( 500,   0,   0, 0); //potion
        if (id == 14) (hp, atk, mgk, mod) = (1000,   0,   0, 0); // ether
        if (id == 15) (hp, atk, mgk, mod) = (1500,   0,   0, 4); //elixir
        if (id == 16) (hp, atk, mgk, mod) = (2000,   0,   0, 1); // nectar
        if (id == 17) (hp, atk, mgk, mod) = (2500,   0,   0, 5); // ambrosia
        if (id == 18) (hp, atk, mgk, mod) = (3000,   0,   0, 5); // cornucopia

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function rarity(uint256 id) public pure returns (bytes10 packed) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        // Rarities are equal among all classes
        if (id == 1) (hp, atk, mgk, mod) = (500,0,0,0); // Common
        if (id == 2) (hp, atk, mgk, mod) = (500,0,0,4); // Uncommon
        if (id == 3) (hp, atk, mgk, mod) = (500,500,0,5); // Rare
        if (id == 4) (hp, atk, mgk, mod) = (500,500,0,13);// Epic
        if (id == 5) (hp, atk, mgk, mod) = (500,500,500,13); // Legendary
        if (id == 6) (hp, atk, mgk, mod) = (500,500,500,15); // Mythic

        packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));
    }

    function specialTraits(uint256 id) public pure returns (bytes10[6] memory stats) {
        (uint16 hp, uint16 atk, uint16 mgk, uint16 mod) = (0,0,0,0);

        if (id == 11) (hp, atk, mgk, mod) = (10000, 10000,     0, 12); // Alexander Great
        if (id == 22) (hp, atk, mgk, mod) = ( 5000,  5000, 10000, 10); // Hou Yi
        if (id == 33) (hp, atk, mgk, mod) = ( 5000, 10000,  5000,  6); // Fujibayashi
        if (id == 44) (hp, atk, mgk, mod) = (15000,     0,  5000,  5); // Rasputin
        if (id == 55) (hp, atk, mgk, mod) = (10000,     0, 10000,  3); // Merlin
        if (id == 66) (hp, atk, mgk, mod) = (12000, 12000,     0,  9); // Mutant Ape
        if (id == 77) (hp, atk, mgk, mod) = (14000,  7000,  7000, 15); // Brahma

        bytes10 packed = bytes10(abi.encodePacked(hp,atk,mgk,mod, uint16(0)));

        stats = [packed, bytes10(0), bytes10(0), bytes10(0), bytes10(0), bytes10(0)];
    }
}
