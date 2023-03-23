// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Drop.sol";

contract ERC721NESDrop is ERC721Drop {
    address public stakingController;

    // Event published when a token is staked.
    event Staked(uint256 tokenId);
    // Event published when a token is unstaked.
    event Unstaked(uint256 tokenId);

    mapping(uint256 => bool) public tokenToIsStaked;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient
    )
        ERC721Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {}

    function _setStakingController(address _stakingController) internal {
        stakingController = _stakingController;
    }

    /**
     *  @dev returns whether a token is currently staked
     */
    function isStaked(uint256 tokenId) public view returns (bool) {
        return tokenToIsStaked[tokenId];
    }

    /**
     *  @dev marks a token as staked, calling this function
     *  you disable the ability to transfer the token.
     */
    function _stake(uint256 tokenId) internal {
        require(!isStaked(tokenId), "token is already staked");

        tokenToIsStaked[tokenId] = true;
        emit Staked(tokenId);
    }

    /**
     *  @dev marks a token as unstaked. By calling this function
     *  you re-enable the ability to transfer the token.
     */
    function _unstake(uint256 tokenId) internal {
        require(isStaked(tokenId), "token isn't staked");

        tokenToIsStaked[tokenId] = false;
        emit Unstaked(tokenId);
    }

    /**
     *  @dev marks a token as staked, can only be performed by delegated
     *  staking controller contract. By calling this function you
     *  disable the ability to transfer the token.
     */
    function stakeFromController(uint256 tokenId, address originator) public {
        require(
            msg.sender == stakingController,
            "Function can only be called from staking controller contract"
        );
        require(
            ownerOf(tokenId) == originator,
            "Originator is not the owner of this token"
        );

        _stake(tokenId);
    }

    /**
     *  @dev marks a token as unstaked, can only be performed delegated
     *  staking controller contract. By calling this function you
     *  re-enable the ability to transfer the token.
     */
    function unstakeFromController(uint256 tokenId, address originator) public {
        require(
            msg.sender == stakingController,
            "Function can only be called from staking controller contract"
        );
        require(
            ownerOf(tokenId) == originator,
            "Originator is not the owner of this token"
        );

        _unstake(tokenId);
    }

    /**
     *  @dev perform safe mint and stake
     */
    function _safemintAndStake(address to, uint256 quantity) internal {
        uint256 startTokenId = _currentIndex;

        for (uint256 i = 0; i < quantity; i++) {
            startTokenId++;
            tokenToIsStaked[startTokenId] = true;
        }

        _safeMint(to, quantity, "");
    }

    /**
     *  @dev perform mint and stake
     */
    function _mintAndStake(address to, uint256 quantity) internal {
        uint256 startTokenId = _currentIndex;

        for (uint256 i = 0; i < quantity; i++) {
            startTokenId++;
            tokenToIsStaked[startTokenId] = true;
        }

        _mint(to, quantity);
    }
}
