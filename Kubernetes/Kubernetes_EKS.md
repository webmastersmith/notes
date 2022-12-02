AWS EKSctl

us-east-1

aws tutorial

- <https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html>
- <https://www.youtube.com/watch?v=pNECqaxyewQ>

Chantel

- eksctl create cluster --name p2 --version 1.19 --region us-east-2
  --nodegroup-name standard-nodes --node-type t3.small --nodes 2
  --managed --node-ami-family Ubuntu2004

schema

- <https://eksctl.io/usage/schema/>

examples

- <https://github.com/weaveworks/eksctl/tree/main/examples>

aws roles

-  <https://eksctl.io/usage/minimum-iam-policies/>
- aws sts get-caller-identity

update eksctl config file

- aws eks update-kubeconfig --name flaskapp-v3

create

eksctl create cluster -f kubernetes-start.yaml

cli

- ami-052efd3df9dad4825 //Optimized Amazon EKS on Ubuntu LTS Server
  22.04

<table>
<tbody>
<tr class="odd">
<td><p>eksctl create cluster \</p>
<p> --name bryon-cluster \</p>
<p> --version 1.22 \</p>
<p> --region us-east-1 \</p>
<p> --nodegroup-name worker-node \</p>
<p> --node-ami-family=Ubuntu2004 \</p>
<p> --node-type t2.micro \</p>
<p> --nodes 2 \</p>
<p> --spot=true \</p>
<p> --ssh-access \</p>
<p> --ssh-public-key=./.ssh/id_rsa.pub</p>
<p># find vpc id's</p>
<p># create security group for your vpc</p>
<p>aws ec2 create-security-group \</p>
<p>--region us-east-1 \</p>
<p>--group-name efs-mount-sg \</p>
<p>--description "Amazon EFS for EKS, SG for mount target" \</p>
<p>--vpc-id vpc-1234567ab12a345cd</p>
<p># create one node group with two m5.large nodes</p>
<p>eksctl create cluster \</p>
<p> --name myekscluster \</p>
<p> --region us-east-1 \</p>
<p> --zones us-east-1a,us-east-1b \</p>
<p> --managed \</p>
<p> --nodegroup-name mynodegroup</p>
<p># eksctl create cluster -f cluster.yaml --dry-run</p>
<p># delete cluster</p>
<p>eksctl delete cluster --region=us-east-1 --name=bryon-cluster --wait
//wait till all resources deleted before moving on.</p>
<p>eksctl delete cluster --name=&lt;name&gt;
[--region=&lt;region&gt;]</p></td>
</tr>
</tbody>
</table>

delete

eksctl delete cluster -f kubernetes-start.yaml --wait

to upgrade, must create new nodegroup name change file:

- name: primary
- name: primary-1-18

eksctl upgrade cluster --config-file kubernetes-start.yaml --approve
//this upgrades the control plane

eksctl create nodegroup --config-file kubernetes-start.yaml //upgrade
the nodes

eksctl delete nodegroup --config-file kubernetes-start.yaml
--only-missing //only delete old nodes

eksctl delete nodegroup --config-file kub-primary-start.yaml

aws cloudformation delete-stack --stack-name STACKNAME

\#auto delete

aws cloudformation delete-stack --stack-name \$(aws cloudformation
list-stacks \| jq -r '.StackSummaries\[0\] \| .StackName')

\#delete cluster

aws eks delete-cluster --name CLUSTERNAME

view stack

- aws cloudformation list-stacks

aws cloudformation list-stacks --query StackSummaries\[\].StackName

eksctl utils describe-stacks --region=us-east-1 --cluster=flaskapp

\#** Cluster has nodegroups attached**

aws eks list-nodegroups --cluster-name bryon-cluster-Ew9YKY

aws eks list-nodegroups --cluster-name bryon-cluster-Ew9YKY \| jq
'.nodegroups'

aws eks list-nodegroups --cluster-name app-opal-weapon

aws eks delete-nodegroup --cluster-name app-opal-weapon --nodegroup-name
winning-chipmunk

aws eks delete-cluster --name app-opal-weapon

eksctl delete nodegroup \\

--cluster bryon-cluster-Ew9YKY \\

--region us-east-1

--name "\$(aws eks list-nodegroups --cluster-name bryon-cluster-Ew9YKY
\| jq '.nodegroups')"

\# takes a few minutes to drain nodes. wait 3 minutes.

for i in \$(aws cloudformation list-stacks --query
StackSummaries\[\].StackName \| tr -d \[\],\\"); do aws cloudformation
delete-stack --stack-name \$i;done

\# stack

aws cloudformation delete-stack --stack-name my-stack

kubernetes-start.yaml //you must echo to expand the variables.

<table>
<tbody>
<tr class="odd">
<td><p>cat &lt;&lt; EOF &gt; kubernetes-start.yaml</p>
<p>---</p>
<p>apiVersion: eksctl.io/v1alpha5</p>
<p>kind: ClusterConfig</p>
<p>metadata:</p>
<p> name: flaskapp</p>
<p> region: ${AWS_REGION}</p>
<p> version: "1.22"</p>
<p>availabilityZones: ["${AZS[0]}", "${AZS[1]}", "${AZS[2]}"]</p>
<p>managedNodeGroups:</p>
<p>- name: nodegroup</p>
<p> desiredCapacity: 3</p>
<p> instanceType: t3.small</p>
<p> ssh:</p>
<p> publicKeyName: Kubernetes_Cluster</p>
<p> # enableSsm: true</p>
<p> </p>
<p># To enable all of the control plane logs, uncomment below:</p>
<p># cloudWatch:</p>
<p># clusterLogging:</p>
<p># enableTypes: ["*"]</p>
<p>#secretsEncryption:</p>
<p># keyARN: ${MASTER_ARN}</p>
<p>EOF</p></td>
</tr>
</tbody>
</table>

simple.yaml // eks create cluster -f simple.yaml

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: eksctl.io/v1alpha5</p>
<p>kind: ClusterConfig</p>
<p>metadata:</p>
<p> name: bryon-cluster-v1</p>
<p> region: us-east-1</p>
<p> version: "1.22"</p>
<p>availabilityZones:</p>
<p>- us-east-1a</p>
<p>- us-east-1b</p>
<p>managedNodeGroups:</p>
<p> - name: worker-node</p>
<p> labesl:</p>
<p> role: worker</p>
<p> instanceType: t2.small</p>
<p> desiredCapacity: 1</p>
<p> volumeSize: 20</p></td>
</tr>
</tbody>
</table>

cluster.yaml //broken

<table>
<tbody>
<tr class="odd">
<td><p>apiVersion: eksctl.io/v1alpha5</p>
<p>kind: ClusterConfig</p>
<p>metadata:</p>
<p> name: bryon-cluster</p>
<p> region: us-east-1</p>
<p> version: "1.22"</p>
<p>vpc:</p>
<p> publicAccessCIDRs: ["24.245.76.148/32"]</p>
<p> clusterEndpoints:</p>
<p> publicAccess: true</p>
<p> nat:</p>
<p> gateway: Single</p>
<p> sharedNodeSecurityGroup: sg-0904c63ab05a23436</p>
<p> id: "vpc-0461db7cac88b999d"</p>
<p> subnets:</p>
<p> public:</p>
<p> us-east-1a:</p>
<p> id: "subnet-0f633ebd25e46c633"</p>
<p> us-east-1b:</p>
<p> id: "subnet-04c91af5eb36eebe4"</p>
<p> private:</p>
<p> us-east-1a:</p>
<p> id: "subnet-0966b67287baa9d18"</p>
<p> us-east-1b:</p>
<p> id: "subnet-0ad417c2f34f1dc7e"</p>
<p>nodeGroups:</p>
<p> - name: master-node</p>
<p> instanceType: t2.micro</p>
<p> desiredCapacity: 1</p>
<p> amiFamily: Ubuntu2004</p>
<p> availabilityZones: ["us-east-1a"]</p>
<p> ssh:</p>
<p> allow: true # will use ~/.ssh/id_rsa.pub as the default ssh key</p>
<p> - name: worker-node</p>
<p> instanceType: t2.micro</p>
<p> desiredCapacity: 1</p>
<p> amiFamily: Ubuntu2004</p>
<p> availabilityZones: ["us-east-1a"]</p>
<p> ssh:</p>
<p> allow: true # will use ~/.ssh/id_rsa.pub as the default ssh
key</p></td>
</tr>
</tbody>
</table>

awscli

- create cluster

<table>
<tbody>
<tr class="odd">
<td><p>create-cluster</p>
<p>--name &lt;value&gt;</p>
<p>--role-arn &lt;value&gt;</p>
<p>--resources-vpc-config &lt;value&gt;</p>
<p>[--kubernetes-network-config &lt;value&gt;]</p>
<p>[--logging &lt;value&gt;]</p>
<p>[--client-request-token &lt;value&gt;]</p>
<p>[--tags &lt;value&gt;]</p>
<p>[--encryption-config &lt;value&gt;]</p>
<p>[--kubernetes-version &lt;value&gt;]</p>
<p>[--cli-input-json &lt;value&gt;]</p>
<p>[--generate-cli-skeleton &lt;value&gt;]</p></td>
</tr>
</tbody>
</table>
