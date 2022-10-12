# Terraform Exam Study Guide

**[Hashicorp Infrastructure Automation Certification](https://www.hashicorp.com/certification/terraform-associate)**

**[docs](https://developer.hashicorp.com/terraform/docs)**

**[best practices](https://www.terraform-best-practices.com/)**

**[exam questions](https://medium.com/bb-tutorials-and-thoughts/250-practice-questions-for-terraform-associate-certification-7a3ccebe6a1a)**



### Understand infrastructure as code (IaC) concepts <br>
- Explain what IaC is
- Describe the advantages of IaC patterns<br>

1. **What is Infrastructure as Code?**
    <details>
    <summary>show answer</summary>

    ```txt
    You write and execute the code to define, deploy, update, and destroy your infrastructure.
      ```
    </details>

2. **What are the benefits of IaC?**
    <details>
    <summary>show answer</summary>

    <pre>
    <b>a. Automation</b>
    We can bring up the servers with one script and scale up and down based on our load with the same script. <br>
    <b>b. Reusability of the code</b>
    We can reuse the same code <br>
    <b>c. Versioning</b>
    We can check it into version control and we get versioning. 
    Now we can see an incremental history of who changed what, how is our infrastructure actually defined at any given point of time, and we have this transparency of documentationIaC makes changes idempotent, consistent, repeatable, and predictable.
    </pre>
    </details>

3. **How using IaC make it easy to provision infrastructure?**
    <details>
    <summary>show answer</summary>

    ```txt
    IaC makes it easy to provision and apply infrastructure configurations, saving time. It standardizes workflows across different infrastructure providers (e.g., VMware, AWS, Azure, GCP, etc.) by using a common syntax across all of them.
    ```
    </details>

4. **What is Ideompodent in terms of IaC?**
    <details>
    <summary>show answer</summary>

    ```txt
    IaC can be applied throughout the lifecycle, both on the initial build, as well as throughout the life of the infrastructure. Commonly, these are referred to as Day 0 and Day 1 activities. 
    “Day 0” code provisions and configures your initial infrastructure.
    “Day 1” refers to OS and application configurations you apply after you’ve initially built your infrastructure.

    Simple terms
    Your code can be run (terraform apply) multiple times with no change to state if code has not changed.
    ```
    </details>

5. **What are Day 0 and Day 1 activities?**
    <details>
    <summary>show answer</summary>

    ```txt
    IaC can be applied throughout the lifecycle, both on the initial build, as well as throughout the life of the infrastructure. Commonly, these are referred to as Day 0 and Day 1 activities.

    “Day 0” code provisions and configures your initial infrastructure.
    “Day 1” refers to OS and application configurations you apply after you’ve initially built your infrastructure.
    ```
    </details>

6. **What are the use cases of Terraform?**
    <details>
    <summary>show answer</summary>

    ```txt
    Heroku App Setup
    Multi-Tier Applications
    Self-Service Clusters
    Software Demos
    Disposable Environments
    Software Defined Networking
    Resource Schedulers
    Multi-Cloud Deployment
    https://www.terraform.io/intro/use-cases.html
    ```
    </details>

7. **What are the advantages of Terraform?**
    <details>
    <summary>show answer</summary>

    ```txt
    Platform Agnostic
    State Management
    Operator Confidencehttps://learn.hashicorp.com/terraform/getting-started/intro
    ```
    </details>

8. **Where do you describe all the components or your entire data center so that Terraform provision those?**
    <details>
    <summary>show answer</summary>

    ```txt
    Configuration files ends with *.tf
    ```
    </details>

9. **How can Terraform build infrastructure so efficiently?**
    <details>
    <summary>show answer</summary>

    ```txt
    Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.
    ```
    </details>






### 2. Understand Terraform’s purpose (vs other IaC) <br>
### 3. Understand Terraform basics <br>
### 4. Use the Terraform CLI (outside of core workflow) <br>
### 5. Interact with Terraform modules <br>
### 6. Navigate Terraform workflow <br>
### 7. Implement and maintain state <br>
### 8. Read, generate, and modify the configuration <br>
### 9. Understand Terraform Cloud and Enterprise capabilities <br>

