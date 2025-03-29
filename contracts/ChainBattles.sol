// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Counters} from "./Counters.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC721("ChainBattels", "BT") {}

    function generateCharacter(uint256 tokenId) public returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function tokenExists(uint256 tokenId) public view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function decreaseLevel(uint256 tokenId) public {
        require(tokenExists(tokenId), "Nonexistent token");
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        require(tokenIdToLevels[tokenId] > 0, "Level cannot go below 0");

        tokenIdToLevels[tokenId] -= 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function train(uint256 tokenId, int256 levelChange) public {
        require(tokenExists(tokenId), "Nonexistent token");
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        
        if (levelChange > 0) {
            tokenIdToLevels[tokenId] += uint256(levelChange);
        } else {
            uint256 decrease = uint256(-levelChange);
            require(tokenIdToLevels[tokenId] >= decrease, "Level cannot go below 0");
            tokenIdToLevels[tokenId] -= decrease;
        }
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
