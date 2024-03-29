CL=cluster
SVC=notes-svc

NS_STG=notes-staging
NS_DEV=notes-development
NS_PROD=notes-production

REGISTRY=asia-southeast2-docker.pkg.dev/dicoding-gcloud-archi/submission

gke-creds:
	gcloud container clusters get-credentials dicoding-cluster-labs \
		--zone asia-southeast2-a \
		--project dicoding-gcloud-archi

gcp-fw:
	gcloud compute firewall-rules create gke-port \
		--allow tcp:5000

pm2-apply :
	pm2 start pm2.config.js
	pm2 save

pm2-start :
	pm2 start all

pm2-stop :
	pm2 stop all

pm2-delete :
	pm2 delete all

create-namespaces:
	kubectl create ns $(NS_STG)
	kubectl create ns $(NS_DEV)
	kubectl create ns $(NS_PROD)

get-svc-endpoint:
	kubectl get svc -n notes-production

get-nodes-endpoint:
	kubectl get nodes --output wide

helm-install-dev:
	helm install $(SVC)-dev $(CL)/ \
		--values $(CL)/values.yaml \
		-f $(CL)/environments/values-dev.yaml -n $(NS_DEV)

helm-upgrade-dev:
	helm upgrade $(SVC)-dev $(CL)/ \
		--values $(CL)/values.yaml \
		-f $(CL)/environments/values-dev.yaml -n $(NS_DEV)

helm-install-prod:
	helm install $(SVC)-prod $(CL)/ \
		--values $(CL)/values.yaml \
		-f $(CL)/environments/values-prod.yaml -n $(NS_PROD)

helm-upgrade-prod:
	helm upgrade $(SVC)-prod $(CL)/ \
		--values $(CL)/values.yaml \
		-f $(CL)/environments/values-prod.yaml -n $(NS_PROD)

helm-delete:
	helm delete notes-svc-prod

helm-list:
	helm list

artifact-registry-build:
	docker build --tag $(SVC):$(tag) \
    	--file dockerfiles/$(type).dockerfile .

	docker tag $(SVC):$(tag) \
        $(REGISTRY)/$(SVC):$(tag)

	gcloud auth configure-docker asia-southeast2-docker.pkg.dev

	docker push $(REGISTRY)/$(SVC):$(tag)
