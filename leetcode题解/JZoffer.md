









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
                if(i==0&&j==0) continue;
                if(i==0) grid[i][j] = grid[i][j-1];
                else if(j==0) grid[i][j] = grid[i-1][j];
                else grid[i][j] += Math.max(grid[i-1][j],grid[i][j-1]);
            }
        }
        return grid[m-1][n-1];
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

