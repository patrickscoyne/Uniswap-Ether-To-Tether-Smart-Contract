// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapETH_Teth {
  address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ;

  IUniswapV2Router02 public uniswapRouter;
  // This is setup for the Ropsten Test Network, uniswap router address is the same on all networks
  address private TetherRop = 0xB404c51BBC10dcBE948077F18a4B8E553D160084 ;

  constructor() {
    uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
  }
  receive() external payable {
      uint256 _ETHin = msg.value;
      uint dline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
      address[] memory TethPath = new address[](2);
      TethPath = getPathForETHtoTeth();
      uint AmtTeth = uniswapRouter.getAmountsOut(_ETHin, TethPath)[1];
      uniswapRouter.swapExactETHForTokens{value : msg. value}(AmtTeth, TethPath, address(this), dline);
  }
  function getPathForETHtoTeth() private view returns (address[] memory) {
    address[] memory path = new address[](2);
    path[0] = uniswapRouter.WETH();
    path[1] = TetherRop;
    return path;
  }
}