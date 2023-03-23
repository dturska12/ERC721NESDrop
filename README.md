About this project:

Modified thirdweb's NFTDrop to allow for NES (Non Escrow Staking) This allows holders to stake their NFTs without the token ever leaving their wallet. 

ERC-721 NES, or Non Escrow Staking, is a novel implementation of a staking model that does not require the owner of a token to lock it into an escrow contract. What that means is the token never moves during the staking process, unlike traditional protocols where you receive a coupon to then redeem later for your staked tokens. Instead, the token is flagged as non transferrable for the entire staking duration. In this way, the owner of a token has zero exposure to the risk of a staking protocol being compromised and their tokens stolen.

ERC-721 NES provides an interface to staking protocols by decorating the prototypical ERC-721 contract with a few additional methods and maintaining one new piece of state. Now, instead of a custodial approach where the owner relinquishes all the power over their token, a signal based locking mechanism can be employed.

_stake(uint256 tokenId) // locks the token

_unstake(uint256 tokenId) // unlocks the token

isStaked(uint256 tokenId) // returns a boolean indicating the staked status of the token

address stakingController // address of the staking contract
