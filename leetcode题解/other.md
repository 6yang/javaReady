## 1. LRU

```java
public class Solution {

    static class Node{
        int key,value;
        Node pre,next;
        public Node(int key ,int  value){
            this.key = key;
            this.value = value;
        }
    }
    private Map<Integer,Node> cache = new HashMap<>();
    private Node head = new Node(-1,-1);
    private Node tail = new Node(-1,-1);
    private int k ;
    
    public int[] LRU (int[][] operators, int k) {
        // write code here
        this.k = k ;
        head.next = tail;
        tail.pre = head;
        int len = (int) Arrays.stream(operators).filter(x->x[0]==2).count();
        int [] ans = new int[len];
        int idx = 0;
        for(int i= 0;i<operators.length;i++){
            if(operators[i][0]==1){
                set(operators[i][1],operators[i][2]);
            }else{
                ans[idx++] = get(operators[i][1]);
            }
        }
        return ans;
    }
    
    public int get (int key ){
        if(cache.containsKey(key)){
            Node node = cache.get(key);
            node.pre.next = node.next;
            node.next.pre = node.pre;
            
            removeToHead(node);
            return node.value;
        }
        return -1;
    }
    public void set(int key ,int value){
        if(get(key)> -1){
             cache.get(key).value = value;
        }else{
            if(cache.size()==k){
                int rk = tail.pre.key;
                tail.pre.pre.next = tail;
                tail.pre = tail.pre.pre;
                cache.remove(rk);
            }
            Node node = new Node(key,value);
            cache.put(key,node);
            removeToHead(node);
            
        }
    }
    public void removeToHead(Node node){
        node.next = head.next;
        head.next.pre = node;
        head.next = node;
        node.pre = head;
    }
    
}
```

