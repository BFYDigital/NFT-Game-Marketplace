// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ZombieMarketplace is Ownable {
    /**
     *@dev zombie trade status
     */
    enum TradeStatus {
        Open,
        Closed,
        Completed
    }

    /**
     * @dev zombie trade struct
     */
    struct ZombieTrade {
        uint256 id;
        uint256 zombieId;
        uint256 price;
        address owner;
        TradeStatus status;
    }

    /**
     * @dev Emitted when a new trade is opened
     * @param _tradeId The id of the newly opened trade
     * @param _zombieId The id of the zombie to be traded
     */
    event TradeOpened(uint256 indexed _tradeId, uint256 indexed _zombieId);

    /**
     * @dev Emitted when a new trade is closed
     * @param _tradeId The id of the newly opened trade
     */
    event TradeClosed(uint256 indexed _tradeId);

    /**
     * @dev Emitted when a new trade is completed
     * @param _tradeId The id of the newly opened trade
     */
    event TradeCompleted(uint256 indexed _tradeId);

    /**
     * @dev Tracks zombie trades to their respective IDs
     */
    mapping(uint256 => ZombieTrade) public trades;

    /**
     * @dev keep track of zombies to their trade ids
     */
    mapping(uint256 => uint256) private _zombieIdToTradeId;

    /**
     *@dev Keeps track of how many trades there are and trade ID assignment
     */
    uint256 public tradeCounter = 1;

    /**
     *@dev ERC721 based FeedingZombie contract to be bought and sold
     */
    ERC721 public zombieToken;

    /**
     *@dev
     */
    modifier onlyOpen(uint256 _tradeId) {
        require(
            trades[_tradeId].status == TradeStatus.Open,
            "trade is not open"
        );
        _;
    }

    constructor(address _zombieContractAddress) {
        zombieToken = ERC721(_zombieContractAddress);
    }

    /**
     * @dev Returns a paginated list of trades
     * @param _perPage How many trades to display per page
     * @param _page The current page number
     */
    function getTrades(uint256 _perPage, uint256 _page)
        external
        view
        returns (ZombieTrade[] memory)
    {
        ZombieTrade[] memory result = new ZombieTrade[](_perPage);
        for (
            uint256 i = _perPage * _page - _perPage;
            i < _perPage * _page;
            i++
        ) {
            result[i] = trades[i];
        }
        return result;
    }

    /**
     * @dev Request approval from the Zombie token contract
     * @param _tokenId zombie token id
     */
    function requestApproval(uint256 _tokenId) external payable {
        zombieToken.approve(address(this), _tokenId);
    }

    /**
     * @dev Allows users to put up a zombie for sale
     * @param _zombieId The ID of the zombie up for sale
     * @param _price The price of the zombie
     */
    function createTrade(uint256 _zombieId, uint256 _price) external payable {
        // lets confirm an open trade for this zombe does not exist
        uint256 tradeId = _zombieIdToTradeId[_zombieId];
        if (tradeId > 0) {
            require(
                trades[tradeId].status != TradeStatus.Open,
                "there is an open trade for this zombie"
            );
        }

        zombieToken.transferFrom(msg.sender, address(this), _zombieId);
        uint256 currentTradeId = tradeCounter;
        trades[currentTradeId] = ZombieTrade(
            currentTradeId,
            _zombieId,
            _price,
            msg.sender,
            TradeStatus.Open
        );
        tradeCounter += 1;
        emit TradeOpened(currentTradeId, _zombieId);
    }

    /**
     * @dev Allow users to cancel their own open trades
     * @param _tradeId the ID of the user's trade
     */
    function closeTrade(uint256 _tradeId) external onlyOpen(_tradeId) {
        ZombieTrade storage trade = trades[_tradeId];
        require(msg.sender == trade.owner, "only the owner can close a trade");

        zombieToken.transferFrom(address(this), msg.sender, trade.zombieId);
        trade.status = TradeStatus.Closed;
        emit TradeClosed(_tradeId);
    }

    /**
     * @dev Allow users to purchase a zombie token from other users
     * @param _tradeId the trade ID
     */
    function completeTrade(uint256 _tradeId)
        external
        payable
        onlyOpen(_tradeId)
    {
        ZombieTrade storage trade = trades[_tradeId];
        (bool success, ) = address(trade.owner).call{value: trade.price}("");
        require(success, "unable to transfer eth");
        zombieToken.transferFrom(address(this), msg.sender, trade.zombieId);

        trade.status = TradeStatus.Completed;
        emit TradeCompleted(_tradeId);
    }
}
