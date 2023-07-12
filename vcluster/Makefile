


kubeconfig:
	@kubectl get secret vc-vcluster -n operations --template={{.data.config}} | base64 -d > config
	# https://74.220.31.55:443
.PHONY: kubeconfig

vcluster:
	@vcluster create operations-vcluster -n operations -f vcluster.yaml
.PHONY: vcluster

delete:
	@vcluster delete operations-vcluster -n operations
.PHONY: delete