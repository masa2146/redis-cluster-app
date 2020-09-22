# Installing
Run *install-redis-cluster.sh* on each one system.
And run below command 

```sh
redis-cli --cluster create example_ip1:6379 example_ip2:6379 example_ip3:6379 example_ip4:6379 example_ip5:6379 example_ip6:6379 --cluster-replicas 1
```