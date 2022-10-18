# 3. Longest substring without repeating chars
# sliding window
import math


a = [5, 1, 3, 2, 11, 5, 7, 8]
b = [1, 2, 3, 5, 4, 8, 6, 2]


def sliding_window(nums, size):
    total = 0
    max_total = -math.inf

    for i in range(len(nums)):
        # add next num to sum
        total += nums[i]
        # check if nums is greater than or equal to size
        if i >= size - 1:
            max_total = max(total, max_total)
            # subtract the first number.
            total -= nums[i - (size - 1)]
    return max_total


print(sliding_window(a, 3))
print(sliding_window(b, 3))
