// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";



contract Test7Token is ERC20 {
    address private owner;

    ERC721Token private erc721Token;
    ERC1155Collection private erc1155Collection;

    
    // Events ---------------------------------------------------------------------------
    event EventERC20(string _action, address _account, uint256 _amount);

    
    // Modifiers ------------------------------------------------------------------------
    modifier onlyOwner {
      require(msg.sender == owner, "You must be an owner to call this function");
      _;
   }
    
    // Constructor ----------------------------------------------------------------------
    constructor() ERC20("Test7", "TST7") {
        uint128 MILLION = 1000000;

        owner = msg.sender;
        mint(owner, 1000 * MILLION);
    }
    
    // Functions ------------------------------------------------------------------------
    /**
     * Creates tokens and assign to address
     */
    function mint(address _account, uint256 _amount) public onlyOwner {
        _mint(_account, _amount);
        emit EventERC20("Mint", _account, _amount);
    }
    
    /**
     * Destroys tokens from address
     */
    function burn(address _account, uint256 _amount) public onlyOwner {
        _burn(_account, _amount);
        emit EventERC20("Burn", _account, _amount);
    }    
    
    /**
     * Returns contract owner
     */
    function getOwner() public view virtual returns (address) {
        return owner;
    }

    /**
     * Returns wallet address
     */
    function getWallet() public view virtual returns (address) {
        return msg.sender;
    }
    
    /**
     * Returns the number of BNB tokens owned by address.
     */    
    function getBnbBalanceOf() public view virtual returns (uint256) {
        return address(msg.sender).balance;
    }
    
    /**
     * Returns the number of TST7 tokens owned by address.
     */   
    function getTst7BalanceOf() public view virtual returns (uint256) {
        return balanceOf(msg.sender);
    }  
    
    
    // Functions ERC721 -----------------------------------------------------------------
    /**
     * Deploys smart-contract from ERC721
     */   
    function createERC721(string memory _name, string memory _symbol) public {
        erc721Token = new ERC721Token(_name, _symbol);
    }
    
    /**
     * Get address where ERC721 is deployed
     */
    function getAddressERC721() public view virtual returns (address) {
        return address(erc721Token);
    }

    /**
     * Returns the number of ERC721 tokens owned by address.
     */    
    function getErc721BalanceOf() public view virtual returns(uint256)  {
        return erc721Token.balanceOf(msg.sender);
    }
    
    /**
     * Set owner of ERC721
     */
    function setOwnerErc721(address _account) public {
        erc721Token.setOwner(_account);
    }
    
    // Functions ERC1155 ----------------------------------------------------------------
    /**
     * Deploys smart-contract from ERC1155
     */
    function createERC1155() public {
        erc1155Collection = new ERC1155Collection();
    }
    
    /**
     * Get address where ERC1155 is deployed
     */
    function getAddressERC1155() public view virtual returns (address) {
        return address(erc1155Collection);
    }

    /**
     * Returns the number of ERC1155 tokens owned by address.
     */      
    function getErc1155BalanceOf(address[] memory owners, uint256[] memory ids) public view virtual returns(uint256[] memory)  {
        //address[] memory owners = new address[](3);
        //owners[0] = address(msg.sender);
        //owners[1] = address(msg.sender);
        //owners[2] = address(msg.sender);

        return erc1155Collection.balanceOfBatch(owners, ids);
    }
    
    /**
     * Set owner of ERC1155
     */
    function setOwnerErc1155(address _account) public {
        erc1155Collection.setOwner(_account);
    }
}

contract ERC721Token is ERC721 {
    address private owner;
    
    // Events ---------------------------------------------------------------------------
    event MintERC721(address _account, uint256 _tokenId);
    
    // Modifiers ------------------------------------------------------------------------
    modifier onlyOwner {
      require(msg.sender == owner, "You must be an owner to call this function");
      _;
   }

    // Constructor ----------------------------------------------------------------------
    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
        
        mint(owner, 1);
        mint(owner, 2);
        mint(owner, 3);
    }


    // Functions ------------------------------------------------------------------------
    function setOwner(address _account) external onlyOwner {
        owner = _account;
    }
    
    function mint(address _account, uint256 _tokenId) public onlyOwner {
        _mint(_account, _tokenId);
        emit MintERC721(_account, _tokenId);
    }
    
}

contract ERC1155Collection is ERC1155 {
    address public owner;
    uint256 private count;

    
    // Events ---------------------------------------------------------------------------
    event MintERC1155(address _account, uint256 _amount, uint256 _id);
    
    // Modifiers ------------------------------------------------------------------------
    modifier onlyOwner {
      require(msg.sender == owner, "You must be an owner to call this function");
      _;
   }
   
    // Constructor ----------------------------------------------------------------------
    constructor() ERC1155("") {
        owner = msg.sender;
        count = 0;
    }
    
    // Functions ------------------------------------------------------------------------
    function setOwner(address _account) external onlyOwner {
        owner = _account;
    }
    
    function addToken(address _account, uint256 _initialSupply) public onlyOwner {
        count++;

        _mint(_account, count, _initialSupply, "");
        emit MintERC1155(_account, _initialSupply, count);
    }
    
}