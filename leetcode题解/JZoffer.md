









## 40、最小的K个数

### 1、快排思路

```java
	public int[] getLeastNumbers(int[] arr, int k) {
        if(arr.length==0 ) return new int[]{};
        quickSortK(arr,0,arr.length-1,k);
        int []res = new int[k];
        for (int i = 0; i < k; i++) {
            res[i] = arr[i];
        }
        return res;
    }

    private void quickSortK(int[] arr, int low, int high, int k) {
        if(low<high){
            int i = low;
            int j = high;
            int temp = arr[i];
            if(i == k) return ;
            while(i<j){
                while(i<j&&temp<arr[j]) j--;
                if(i<j){
                    arr[i] = arr[j];
                    i++;
                }
                while(i<j&&temp>arr[i]) i++;
                if(i<j){
                    arr[j] = arr[i];
                    j--;
                }
            }
            arr[i] = temp;
            quickSortK(arr,low,i-1,k);
            if(k>i){
                quickSortK(arr,i+1,high,k);
            }
        }
    }
```

### 2、堆

```java
	public int[] getLeastNumbers(int[] arr, int k) {
        if (k == 0 || arr.length == 0) {
            return new int[0];
        }
        // 默认是小根堆，实现大根堆需要重写一下比较器。
        Queue<Integer> pq = new PriorityQueue<>((v1, v2) -> v2 - v1);
        for (int num: arr) {
            if (pq.size() < k) {
                pq.offer(num);
            } else if (num < pq.peek()) {
                pq.poll();
                pq.offer(num);
            }
        }
        
        // 返回堆中的元素
        int[] res = new int[pq.size()];
        int idx = 0;
        for(int num: pq) {
            res[idx++] = num;
        }
        return res;
    }

```

## 41、数据流中的中位数

> 思路：采用两个堆
>
> 大根堆保存较小的一半
>
> 小跟堆保存较大的一半
>
> 如果奇数：那么从小根堆的顶部取
>
> 如果偶数：两个堆顶部加起来/2

```java
class MedianFinder {
        /**
         * initialize your data structure here.
         */
        Queue<Integer> smallHeap;
        Queue<Integer> bigHeap;

        public MedianFinder() {
            smallHeap = new PriorityQueue<>(); // 小顶堆，放较大的一半
            bigHeap = new PriorityQueue<>((v1,v2)->v2-v1); //大顶堆，放较小的一半
        }

        public void addNum(int num) {
            if(smallHeap.size() == bigHeap.size()){
                bigHeap.add(num);
                smallHeap.add(bigHeap.poll());
            }else{
                smallHeap.add(num);
                bigHeap.add(smallHeap.poll());
            }
        }

        public double findMedian() {
            return (smallHeap.size()+bigHeap.size())%2!=0?smallHeap.peek():(smallHeap.peek()+bigHeap.peek())/2.0;
        }
    }
```



## 42、连续子数组的最大和

```java
	public int maxSubArray(int[] nums) {
        int res = nums[0];
        for (int i = 1; i < nums.length; i++) {
            nums[i] += Math.max(nums[i-1],0);
            // dp数组复用nums数组
            // dp[i] = dp[i-1]+nums[i]   dp[i-1]>0
            // dp[i] = dp[i]             dp[i-1]<0
            res = Math.max(res,nums[i]);
        }
        return res;
    }
```



## 43、1-n整数中1出现的次数

> 思路：dfs

```java
	class Solution {
        public int countDigitOne(int n) {
            return dfs(n);
        }

        private int dfs(int n) {
            if(n<=0){
                return 0;
            }
            String number = String.valueOf(n);
            int high = number.charAt(0) - '0'; // 最高位n=2346,则high=2
            int belowPart = (int) Math.pow(10, number.length() - 1); // n=2346,则belowPart=2000
            int lastPart = n - high * belowPart;// n=2346则,lastPart=346
            if(high==1){
                // case 1234
                // 0-234 dfs(lastPart)
                // 0-999 dfs(belowPart-1)
                // 1000-1234 最高位1的个数,等于lastPart+1个
                return dfs(lastPart)+dfs(belowPart-1)+lastPart+1;
            }else{
                // case 3456
                // 0-456 dfs(lastPart)
                // 1000-1999 最高位1的个数，belowPart个
                // 0-999*3 3*dfs(below-1)
                return dfs(lastPart)+high*dfs(belowPart-1)+belowPart;
            }
        }
    }
```

## 44、数字序列中某一位的数字

> 思路：1.确定起始值和位
>
> ​			2.确定所在的数
>
> ​			3.确定在所在数的第几个数字

```java
	class Solution {
        public int findNthDigit(int n) {
            int digit = 1;
            long start = 1;
            long count = 9;
            // 1确定开始和位数
            while (n > count) {
                n -= count;
                digit += 1; //位数 0-9 1 | 10-99 2 | 100-999 3 | ...
                start *= 10;//开始 0-9 0 | 10-99 10 | 100-999 100 | ...
                count = 9 * start * digit; //数字个数 0-9 9 | 10-99 180 | 100-999 2700
            }
            // 2确定n所在的数字
            long num = start + (n - 1) / digit;
            // 3确定n所在数字第几个
            return Long.toString(num).charAt((n - 1) % digit) - '0';
        }
    }
```



## 45、把数组排成最小的数

> 思路：使用排序
>
> 如果 x+y > y+x 那么 x>y
>
> 如果 x+y < y+x 那么 y<x

**1、自定义快排**

```java
 public String minNumber_quickSort(int[] nums) {
            String[] strs = new String[nums.length];
            for (int i = 0; i < nums.length; i++) {
                strs[i] = String.valueOf(nums[i]);
            }
            quickSort(strs, 0, strs.length - 1);
            StringBuilder res = new StringBuilder();
            for (String str : strs) {
                res.append(str);
            }
            return res.toString();
        }

        // 排序规则  例子 3 32 68
        // 如果332>323，那么32就是较小的一方 32 3 68
        private void quickSort(String[] strs, int l, int r) {
            if (l < r) {
                int i = l;
                int j = r;
                String temp = strs[i];
                while (i < j) {
                    while ((strs[j] + strs[l]).compareTo(strs[l] + strs[j]) >= 0 && i < j) j--;
                    while ((strs[i] + strs[l]).compareTo(strs[l] + strs[i]) <= 0 && i < j) i++;
                    temp = strs[i];
                    strs[i] = strs[j];
                    strs[j] = temp;
                }
                strs[i] = strs[l];
                strs[l] = temp;
                quickSort(strs,l,i-1);
                quickSort(strs,i+1,r);
            }
        }
```

**2、使用jdk自带排序Arrays.sort()**

```java
 	public String minNumber(int[] nums) {
            String[] strs = new String[nums.length];
            for (int i = 0; i < nums.length; i++) {
                strs[i] = String.valueOf(nums[i]);
            }
            Arrays.sort(strs,(o1,o2)->(o1+o2).compareTo(o2+o1));
            StringBuilder res = new StringBuilder();
            for (String str : strs) {
                res.append(str);
            }
            return res.toString();
        }
```



## 46、把数字翻译成字符串

> 思路：动态规划
>
> 和跳台阶类似的一道题

**1、dp数组**

```java
		// 动态规划，跳台阶
        public int translateNum_dp(int num) {
            String str = String.valueOf(num);
            int[] dp = new int[str.length() + 1];
            dp[0] = 1;
            dp[1] = 1;
            for (int i = 2; i <= str.length(); i++) {
                String number = str.substring(i - 2, i);
                if (number.compareTo("10") >= 0 && number.compareTo("25") <= 0) {
                    dp[i] = dp[i - 1] + dp[i - 2];
                } else {
                    dp[i] = dp[i - 1];
                }
            }
            return dp[str.length()];
        }
```

**2、优化dp数组**

```Java
		// 动态规划，跳台阶 优化
        public int translateNum(int num) {
            String str = String.valueOf(num);
            int a = 1;
            int b = 1;
            for (int i = 2; i <= str.length(); i++) {
                String number = str.substring(i - 2, i);
                int c = number.compareTo("10") >= 0 && number.compareTo("25") <= 0 ? a + b : a;
                b = a;
                a = c;

            }
            return a;
        }
```



## 47、礼物的最大价值

### 1、动态规划

> 状态转移方程 
>
> **时间复杂度**：O（M*N）
>
> **空间复杂度**：O(1)

![](img/jz_47_1.png)

**代码**

```java
		public int maxValue(int[][] grid) {
            int m = grid.length;
            int n = grid[0].length;
            for (int i = 0; i < m; i++) {
                for (int j = 0; j < n; j++) {
                    if (i == 0 && j == 0) continue;
                    else if (i == 0) grid[i][j] += grid[i][j - 1];
                    else if (j == 0) grid[i][j] += grid[i - 1][j];
                    else grid[i][j] += Math.max(grid[i - 1][j], grid[i][j - 1]);
                }
            }
            return grid[m - 1][n - 1];
        }
```



## 48、最长不含重复字符的子字符串

> 思路：双指针加哈希

```java
	class Solution {
        public int lengthOfLongestSubstring(String s) {
            if (s == null || s.length() == 0) return 0;
            HashMap<Character, Integer> map = new HashMap<>();
            int i = -1;
            int res = 0;
            for (int j = 0; j < s.length(); j++) {
                if (map.containsKey(s.charAt(j))) {
                    i = Math.max(i, map.get(s.charAt(j)));
                }
                map.put(s.charAt(j), j);
                res = Math.max(res, j - i);
            }
            return res;
        }
    }
```

## 49、丑数

> 思路：动态规划

```java
	class Solution {
        // 一个十分巧妙的动态规划问题
        // 1.我们将前面求得的丑数记录下来，后面的丑数就是前面的丑数*2，*3，*5
        // 2.但是问题来了，我怎么确定已知前面k-1个丑数，我怎么确定第k个丑数呢
        // 3.采取用三个指针的方法，p2,p3,p5
        // 4.index2指向的数字下一次永远*2，p3指向的数字下一次永远*3，p5指向的数字永远*5
        // 5.我们从2*p2 3*p3 5*p5选取最小的一个数字，作为第k个丑数
        // 6.如果第K个丑数==2*p2，也就是说前面0-p2个丑数*2不可能产生比第K个丑数更大的丑数了，所以p2++
        // 7.p3,p5同理
        // 8.返回第n个丑数
        public int nthUglyNumber(int n) {
            int p2 = 0, p3 = 0, p5 = 0;
            int [] dp = new int[n];
            dp[0] = 1; // 1是丑数
            for (int i = 1; i < n; i++) {
                dp[i] = Math.min(dp[p2]*2,Math.min(dp[p3]*3,dp[p5]*5));
                if(dp[i]==dp[p2]*2) p2++;
                if(dp[i]==dp[p3]*3) p3++;
                if(dp[i]==dp[p5]*5) p5++;
            }
            return dp[n-1];
        }
    }
```



## 50、第一次出现一次的字符

> 思路：先把字符出现的次数全部放在new  int[26] 的数组中
>
> 然后对字符串在进行一次扫描，找第一次只出现一次的字符

```java
	public char firstUniqChar(String s) {
        int [] charN = new int[26];
        for (int i = 0; i < s.length(); i++) {
            charN[s.charAt(i)-'a']++;
        }
        for (int i = 0; i < s.length(); i++) {
            if(charN[s.charAt(i)-'a']==1){
                return s.charAt(i);
            }
        }
        return ' ';
    }
```



## 52、两个链表的第一个公共节点

```java
	public class Solution {
        public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
            ListNode p1 = headA;
            ListNode p2 = headB;
            while (p1 != p2) {
                p1 = p1 != null ? p1.next : headB;
                p2 = p2 != null ? p2.next : headA;
            }
            return p1;
        }
    }
```

## 53_I、在排序数组中查找数字 

> 思路：二分查找

```java
	class Solution {
        public int search(int[] nums, int target) {
            int l = 0, r = nums.length-1;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (nums[mid] > target) {
                    r = mid - 1;
                } else if (nums[mid] < target) {
                    l = mid + 1;
                } else {
                    l = mid-1;
                    r = mid+1;
                    while(l>=0&&nums[l] == target) l--;
                    while(r<=nums.length-1&&nums[r] == target) r++;
                    return r-l-1;
                }
            }
            return 0;
        }
    }
```



## 62、约瑟夫环

### 1、数学递推法

> 公式
>
> ![](img/jz_62_1.png)

**代码**

```java
	public int lastRemaining(int n, int m) {
        int pos = 0 ; // 最后留在圈的人的索引
        //从两个人开始模拟
        for (int i = 2; i <= n; i++) {
            pos = (pos + m )%i; //如果圈里面有两个人时候 ，留在圈里人的索引，倒退
        }
        return pos;
    }
```

