pragma solidity 0.8.4;

contract LoopArrayRemoval {
    
  mapping(address => uint256[]) public activeTransactionBlocks;
    
    function add(address user, uint256 preparedBlock) public {
        activeTransactionBlocks[user].push(preparedBlock);
    }
    
    function remove(address user, uint256 preparedBlock) public {
        uint256 index = 99999999999999999999;
        uint256[] storage list = activeTransactionBlocks[user];
        uint256 length = list.length;
        
        for(uint256 x; x < length; x++){
          if(list[x] == preparedBlock){
            index = x;
          }
        }
    
        if(index != 99999999999999999999) {
          list[index] = list[list.length - 1];
          list.pop();
        }
    }
  
    function removeUserActiveBlocks(address user, uint256 preparedBlock) public {
        // Remove active blocks
        uint256 newLength = activeTransactionBlocks[user].length - 1;
        uint256[] memory updated = new uint256[](newLength);
        bool removed = false;
        uint256 updatedIdx = 0;
        for (uint256 i; i < newLength + 1; i++) {
          // Handle case where there could be more than one tx added in a block
          // And only one should be removed
          if (!removed && activeTransactionBlocks[user][i] == preparedBlock) {
            removed = true;
            continue;
          }
          updated[updatedIdx] = activeTransactionBlocks[user][i];
          updatedIdx++;
        }
        activeTransactionBlocks[user] = updated;
  }
}


