const a = [5, 1, 3, 2, 11, 5, 7, 8];
const b = [1, 2, 3, 5, 4, 8, 6, 2];

function maxSubArray(nums, size) {
  let sum = 0,
    max = -Infinity;

  for (let i = 0; i < nums.length; i++) {
    sum += nums[i];
    // start sliding window when i is past or equal size.
    if (i >= size - 1) {
      max = Math.max(sum, max);
      // subtract start of first num.
      sum -= nums[i - (size - 1)];
    }
  }
  return max;
}

// console.time("a");
// console.log(maxSubArray(a, 3)); // 23
// console.timeEnd("a");

// console.time("b");
// console.log(maxSubArray(b, 3)); // 18
// console.timeEnd("b");

const c = [4, 2, 1, 7, 8, 1, 2, 8, 1, 0];
const sw = (nums, size) => {
  let sum = 0,
    max = -Infinity;
  for (let i = 0; i < nums.length; i++) {
    sum += nums[i];
    if (i >= size - 1) {
      max = Math.max(sum, max);
      // subtract first num
      sum -= nums[i - (size - 1)];
    }
  }
  return max;
};

// console.time("c");
// console.log(sw(c, 3)); // 16
// console.timeEnd("c");

// Dynamic Sliding Window
// find smallest substring >=8.
d = [4, 2, 2, 7, 8, 1, 2, 8, 10];
// check size
const isEqual = (num, size) => num >= size;
const dynamicSlidingWindow = (arr, size) => {
  let sum = 0,
    count = 1,
    maxSub = 0;
  for (let i = 0; i < arr.length; i++) {
    sum += arr[i];
    // test if number group is
    if (!isEqual(sum, size)) {
      count++;
      // must be equal
    } else {
      if (count === 1) {
        // it's the smallest possible substring, return early
        return 1;
      } else {
        while (count > 0) {
          // take away from start till under substring.
          sum -= arr[i - (count - 1)];
          if (isEqual(sum, size)) {
            count--;
            if (maxSub > count || maxSub == 0) {
              maxSub = count;
            }
            // false
          } else {
            break;
          }
        }
      }
    }
  }
  return maxSub;
};
// console.log(dynamicSlidingWindow(d, 8));

const dynamicSlidingWindow2 = (arr, size) => {
  let maxSub = Infinity,
    sum = 0,
    count = 0;

  for (let end = 0; end < arr.length; end++) {
    sum += arr[end];
    // test if number group is
    if (count == 1) return 1;
    while (sum >= size) {
      maxSub = Math.min(maxSub, end - count + 1);
      sum -= arr[count];
      count++;
    }
  }
  return maxSub;
};
// console.log(dynamicSlidingWindow2(d, 8));

// longest substring that is <= 2 characters
e = ["A", "A", "A", "H", "H", "I", "B", "C"];
const s = "ADOBECODEBANC";
const t = "NC";
const longestSubstring = (str, subString) => {
  let maxSubStringLength = Infinity,
    startPointer = 0,
    endPointer = 0,
    count = subString.length;

  const chars = [...subString];
  const d = {};
  for (const k of chars) {
    d[k] = 0;
  }
  // iterate string
  for (let windowEnd = endPointer; windowEnd < str.length; windowEnd++) {
    // loop through string with end pointer
    if (chars.includes(str[windowEnd])) {
      // found a char, add number to dict
      d[str[windowEnd]]++;
      // if d count == 1, subtract the count.
      if (d[str[windowEnd]] === 1) {
        count--;
      }
      // track where pointer is.
      endPointer = windowEnd;
      // check if all conditions met.
      if (count === 0) {
        // check if it's the smallest possible chars
        for (
          let windowStart = startPointer;
          windowStart < endPointer;
          windowStart++
        ) {
          // if char matches, remove from dict, change count of dict less than one.
          if (chars.includes(str[windowStart])) {
            d[str[windowStart]]--;
            // change count only if dict char less than one.
            if (d[str[windowStart]] < 1) {
              count++;
              // track pointer start point.
              maxSubStringLength = Math.min(
                maxSubStringLength,
                endPointer + 1 - windowStart
              );
              startPointer = windowStart + 1;
              break;
            }
          }
        }
      }
    }
  }
  return maxSubStringLength;
};
// console.log(longestSubstring(s, t));

const str1 = "pwwkew";
const str2 = "abcabcdbb";
const str3 = " ";
const str4 = "au";
const str5 = "aab";
const str6 = "dvdf";

function longestSub(str) {
  let max = 0,
    d = {},
    startPointer = 0;

  if (str.length === 1) return 1;

  for (let windowEnd = 0; windowEnd < str.length; windowEnd++) {
    // check if letter in dict.
    if (d[str[windowEnd]] === undefined) {
      // add char to dict
      d[str[windowEnd]] = 1;
      max = Math.max(max, Object.keys(d).length);
    } else {
      // start pointer to delete substring
      for (
        let windowStart = startPointer;
        windowStart < windowEnd;
        windowStart++
      ) {
        // check if letters equal. If not drop the letter because it's not contiguous
        startPointer = windowStart + 1;
        if (str[windowStart] !== str[windowEnd]) {
          delete d[str[windowStart]];
          // char is equal. everything else has been deleted.
        } else {
          break;
        }
      }
    }
  }
  return max;
}
console.time("longestSub");
console.log(longestSub(str1)); // 3
console.log(longestSub(str2)); // 4
console.log(longestSub(str3)); // 1
console.log(longestSub(str4)); // 2
console.log(longestSub(str5)); // 2
console.log(longestSub(str6)); // 3
console.timeEnd("longestSub");

function lg(s) {
  let max = 0,
    k = 0;
  for (let i = 0; i < s.length; i++) {
    for (let j = k; j < i; j++) {
      if (s[i] === s[j]) {
        k = j + 1;
        break;
      }
    }
    if (i - k + 1 > max) {
      max = i - k + 1;
    }
  }
  return max;
}
console.time("lg");
console.log(lg(str1));
console.log(lg(str2));
console.log(lg(str3));
console.log(lg(str4));
console.log(lg(str5));
console.log(lg(str6));
console.timeEnd("lg");
