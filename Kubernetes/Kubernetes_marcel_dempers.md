create eks with terraform

- docker run -it --rm -v \${PWD}:/work -w /work --entrypoint /bin/sh
  amazon/aws-cli:latest

  - -v copy everything into work folder and -w watch for changes.
  - yum install -y jq gzip nano tar git unzip wget

sudo terraform.sh

<table>
<tbody>
<tr class="odd">
<td><p># <a
href="https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/cloud/amazon/terraform">https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/cloud/amazon/terraform</a>
</p>
<p># <a
href="https://www.youtube.com/watch?v=Qy2A_yJH5-o">https://www.youtube.com/watch?v=Qy2A_yJH5-o</a>
</p>
<p># docker run -it --rm -v ${PWD}:/work -w /work --entrypoint /bin/sh
amazon/aws-cli:latest</p>
<p>yum install -y jq gzip nano tar git unzip wget</p>
<p>curl -o /tmp/terraform.zip -LO
https://releases.hashicorp.com/terraform/1.2.6/terraform_1.2.6_linux_amd64.zip</p>
<p>unzip /tmp/terraform.zip</p>
<p>chmod +x terraform &amp;&amp; mv terraform /usr/local/bin/</p>
<p>terraform</p></td>
</tr>
</tbody>
</table>
