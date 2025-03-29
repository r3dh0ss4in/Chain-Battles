// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Counters
 * @dev Provides a simple counter utility that can be incremented, decremented, or reset.
 */
library Counters {
    // Defines a struct to hold the counter value
    struct Counter {
        uint256 _value; // The current value of the counter
    }

    /**
     * @dev Returns the current value of the counter.
     * @param counter The counter instance.
     * @return uint256 The current value.
     */
    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    /**
     * @dev Increments the counter by 1.
     * @param counter The counter instance.
     */
    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    /**
     * @dev Decrements the counter by 1.
     * @param counter The counter instance.
     * @notice This function will not underflow; it will revert if the counter is already 0.
     */
    function decrement(Counter storage counter) internal {
        require(counter._value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value -= 1;
        }
    }

    /**
     * @dev Resets the counter to 0.
     * @param counter The counter instance.
     */
    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}