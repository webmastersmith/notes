Kubernetes AWS Tutorial

Set up environmental variables

- <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html>
- export AWS_ACCESS_KEY_ID=AKIANN7EXAMPLE
- export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEbPxRfiCYEXAMPLEKEY
- export AWS_DEFAULT_REGION=us-east-1

EKS Tutorial

- <https://www.eksworkshop.com/010_introduction/>

ENI

- elastic network interface

  - connects two vpc together to talk.
  - aws vpc control plane uses to talk to your vpc worker nodes

EKS (Elastic Kubernetes Service)

- runs on aws vpc separate from your work vpc. talks over the eni.

VPC

- virtual private cloud.
- you have a vpc where your worker nodes run.

Cloud environment setup

- boto3

  - pip3 install --user --upgrade boto3

install kubectl

- <https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html>

<table>
<tbody>
<tr class="odd">
<td><p>sudo curl -L -o /usr/local/bin/kubectl <a
href="https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl">https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl</a></p>
<p>sudo chmod +x /usr/local/bin/kubectl</p></td>
</tr>
</tbody>
</table>

aws cli

- <https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

<table>
<tbody>
<tr class="odd">
<td><p>curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
-o "awscliv2.zip"<br />
unzip awscliv2.zip<br />
sudo ./aws/install</p>
<p># confirm</p>
<p>aws --version</p></td>
</tr>
</tbody>
</table>

get default

- sudo yum -y install jq gettext bash-completion moreutils

install yq for yaml

<table>
<tbody>
<tr class="odd">
<td><p>echo 'yq() {</p>
<p> docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"</p>
<p>}' | tee -a ~/.bashrc &amp;&amp; source ~/.bashrc</p></td>
</tr>
</tbody>
</table>

verify binaries

<table>
<tbody>
<tr class="odd">
<td><p>for command in kubectl jq envsubst aws</p>
<p> do</p>
<p> which $command &amp;&gt;/dev/null &amp;&amp; echo "$command in path"
|| echo "$command NOT FOUND"</p>
<p> done</p></td>
</tr>
</tbody>
</table>

bash completion

<table>
<tbody>
<tr class="odd">
<td><p>kubectl completion bash &gt;&gt; ~/.bash_completion</p>
<p>. /etc/profile.d/bash_completion.sh</p>
<p>. ~/.bash_completion</p></td>
</tr>
</tbody>
</table>

bash variables

<table>
<tbody>
<tr class="odd">
<td><p>export ACCOUNT_ID=$(aws sts get-caller-identity --output text
--query Account)</p>
<p>export AWS_REGION=$(curl -s
169.254.169.254/latest/dynamic/instance-identity/document | jq -r
'.region')</p>
<p>export AZS=($(aws ec2 describe-availability-zones --query
'AvailabilityZones[].ZoneName' --output text --region $AWS_REGION))</p>
<p>echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bashrc</p>
<p>echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bashrc</p>
<p>echo "export AZS=(${AZS[@]})" | tee -a ~/.bashrc</p>
<p>aws configure set default.region ${AWS_REGION}</p>
<p>aws configure get default.region</p></td>
</tr>
</tbody>
</table>

custom managed key

- maybe just for workshop?

<table>
<tbody>
<tr class="odd">
<td><p>aws kms create-alias --alias-name alias/eksworkshop
--target-key-id $(aws kms create-key --query KeyMetadata.Arn --output
text)</p>
<p>export MASTER_ARN=$(aws kms describe-key --key-id alias/eksworkshop
--query KeyMetadata.Arn --output text)</p>
<p>echo "export MASTER_ARN=${MASTER_ARN}" | tee -a
~/.bash_profile</p></td>
</tr>
</tbody>
</table>

download eksctl tool

<table>
<tbody>
<tr class="odd">
<td><p>curl --silent --location
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname
-s)_amd64.tar.gz" | tar xz -C /tmp</p>
<p>sudo mv -v /tmp/eksctl /usr/local/bin</p></td>
</tr>
</tbody>
</table>

eksctl version

enable bash completion

<table>
<tbody>
<tr class="odd">
<td><p>eksctl completion bash &gt;&gt; ~/.bash_completion</p>
<p>. /etc/profile.d/bash_completion.sh</p>
<p>. ~/.bash_completion</p></td>
</tr>
</tbody>
</table>

make sure role is correct

- aws sts get-caller-identity //returns eksworkshop-admin and instance
  id.

eks startup yaml

<table>
<tbody>
<tr class="odd">
<td><p>cat &lt;&lt; EOF &gt; eksworkshop.yaml</p>
<p>---</p>
<p>apiVersion: eksctl.io/v1alpha5</p>
<p>kind: ClusterConfig</p>
<p>metadata:</p>
<p> name: eksworkshop-eksctl</p>
<p> region: ${AWS_REGION}</p>
<p> version: "1.19"</p>
<p>availabilityZones: ["${AZS[0]}", "${AZS[1]}", "${AZS[2]}"]</p>
<p>managedNodeGroups: //provision data you already have</p>
<p>- name: nodegroup</p>
<p> desiredCapacity: 3</p>
<p> instanceType: t3.small</p>
<p> ssh:</p>
<p> enableSsm: true</p>
<p># To enable all of the control plane logs, uncomment below:</p>
<p># cloudWatch:</p>
<p># clusterLogging:</p>
<p># enableTypes: ["*"]</p>
<p>secretsEncryption:</p>
<p> keyARN: ${MASTER_ARN}</p>
<p>EOF</p></td>
</tr>
</tbody>
</table>

enable/delete cluster

- eksctl create cluster -f eksworkshop.yaml
- eksctl delete cluster -f eksworkshop.yaml

first deploy file

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: apps/v1</p>
<p>kind: Deployment</p>
<p>metadata:</p>
<p> name: ecsdemo-nodejs</p>
<p> labels:</p>
<p> app: ecsdemo-nodejs</p>
<p> namespace: default</p>
<p>spec:</p>
<p> replicas: 1</p>
<p> selector:</p>
<p> matchLabels:</p>
<p> app: ecsdemo-nodejs</p>
<p> strategy:</p>
<p> rollingUpdate:</p>
<p> maxSurge: 25%</p>
<p> maxUnavailable: 25%</p>
<p> type: RollingUpdate</p>
<p> template:</p>
<p> metadata:</p>
<p> labels:</p>
<p> app: ecsdemo-nodejs</p>
<p> spec:</p>
<p> containers:</p>
<p> - image: brentley/ecsdemo-nodejs:latest</p>
<p> imagePullPolicy: Always</p>
<p> name: ecsdemo-nodejs</p>
<p> ports:</p>
<p> - containerPort: 3000</p>
<p> protocol: TCP</p></td>
</tr>
</tbody>
</table>

.kube/config -default

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: v1</p>
<p>clusters: null</p>
<p>contexts: null</p>
<p>current-context: ""</p>
<p>kind: Config</p>
<p>preferences: {}</p>
<p>users: null</p></td>
</tr>
</tbody>
</table>

get loadbalancer programatically

|                                                                                                           |
| --------------------------------------------------------------------------------------------------------- |
| ELB=\$(kubectl get service ecsdemo-frontend -o json \| jq -r '.status.loadBalancer.ingress\[\].hostname') |
