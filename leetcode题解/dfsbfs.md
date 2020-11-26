## 200. 岛屿数量

<font color='#e54d42'> DFS </font>

```java
	public int solve (char[][] grid) {
        // write code here
        int m = grid.length;
        int n = grid[0].length;
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if(grid[i][j]=='1'){
                    dfs(grid,i,j);
                    count++;
                }
            }
        }
        return count;
    }

    private void dfs(char[][] grid, int i, int j) {
        if(i<0||i>=grid.length||j<0||j>=grid[0].length||grid[i][j]=='0') return;
        grid[i][j] = '0'; //删除岛屿
        dfs(grid,i-1,j);
        dfs(grid,i,j-1);
        dfs(grid,i+1,j);
        dfs(grid,i,j+1);
    }
```

<font color='#e54d42'> BFS </font>

```java
public int solve (char[][] grid) {
        // write code here
        int m = grid.length;
        int n = grid[0].length;
        int count = 0;
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if(grid[i][j]=='1'){
                    bfs(grid,i,j);
                    count++;
                }
            }
        }
        return count;
    }

    private void bfs(char[][] grid, int i, int j) {
        Queue<int[]> queue = new LinkedList<>();
        queue.add(new int[]{i,j});
        while (!queue.isEmpty()){
            int[] cur = queue.remove();
            i = cur[0];
            j= cur[1];
            if(i>=0&&i<grid.length&&j>=0&&j<grid[0].length&&grid[i][j]=='1'){
                grid[i][j] = '0';
                queue.add(new int[]{i,j-1});
                queue.add(new int[]{i,j+1});
                queue.add(new int[]{i-1,j});
                queue.add(new int[]{i+1,j});
            }
        }
    }
```

