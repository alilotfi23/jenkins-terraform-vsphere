pipeline {
  // Define the agent that will execute the pipeline; 'any' means it can run on any available agent.
  agent any
  
  // Specify the tools required for the pipeline, in this case, Terraform.
  tools {
    "org.jenkinsci.plugins.terraform.TerraformInstallation" // Terraform installation plugin
    "terraform" // Name of the Terraform tool to use
  }
  
  // Define parameters for the pipeline; here, a string parameter for the workspace is created.
  parameters {
    string(name: 'WORKSPACE', defaultValue: 'development', description: 'setting up workspace for terraform')
  }
  
  // Set environment variables for use in the pipeline stages.
  environment {
    TF_HOME = tool('terraform') // Set TF_HOME to the path of the Terraform tool
    TP_LOG = "WARN" // Set logging level for Terraform
    PATH = "$TF_HOME:$PATH" // Update the PATH to include the Terraform binary
  }
  
  stages {
    // Stage to initialize Terraform; prepares the working directory and downloads necessary plugins.
    stage('TerraformInit') {
      steps {
        dir('jenkins-terraform-vsphere/terraform/') { // Change to the specified directory
          sh "terraform init -input=false" // Initialize Terraform without user input
          sh "echo \$PWD" // Output the current working directory for debugging
        }
      }
    }

    // Stage to format Terraform configuration files; checks for formatting issues without modifying files.
    stage('TerraformFormat') {
      steps {
        dir('jenkins-terraform-vsphere/terraform/') {
          sh "terraform fmt -list=true -write=false -diff=true -check=true" // Check formatting
        }
      }
    }

    // Stage to validate the Terraform configuration; checks for syntax errors and other issues.
    stage('TerraformValidate') {
      steps {
        dir('jenkins-terraform-vsphere/terraform/') {
          sh "terraform validate" // Validate the Terraform files
        }
      }
    }

    // Stage to create or select a Terraform workspace and generate an execution plan.
    stage('TerraformPlan') {
      steps {
        dir('jenkins-terraform-vsphere/terraform/') {
          script {
            try {
              // Attempt to create a new workspace; if it exists, catch the error.
              sh "terraform workspace new ${params.WORKSPACE}"
            } catch (err) {
              // If workspace creation fails, select the existing workspace.
              sh "terraform workspace select ${params.WORKSPACE}"
            }
            // Generate the execution plan and output the status code to a file.
            sh "terraform plan -out terraform.tfplan;echo \$? > status"
          }
        }
      }
    }

    // Stage to apply the Terraform plan; requires user confirmation before proceeding.
    stage('TerraformApply') {
      steps {
        script {
          def apply = false // Flag to determine if apply should proceed
          try {
            // Prompt user for confirmation to apply the changes.
            input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
            apply = true // Set apply flag to true if user confirms
          } catch (err) {
            apply = false // Set apply flag to false if user cancels
            currentBuild.result = 'UNSTABLE' // Mark the build as unstable
          }
          // If user confirmed, unstash the plan and apply it.
          if (apply) {
            dir('jenkins-terraform-vsphere/terraform/') {
              unstash "terraform-plan" // Retrieve the previously stored plan
              sh 'terraform apply terraform.tfplan' // Apply the Terraform plan
            }
          }
        }
      }
    }
  }
}
