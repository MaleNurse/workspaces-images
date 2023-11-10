# Winglang AWS OIDC Setup for Github Actions

This Winglang application helps you to set up AWS OpenID Connect (OIDC) for your GitHub Actions.

## Prerequisites

- You should have the Winglang CLI installed `npm install -g winglang@latest`
- Access to an AWS Account and necessary permissions to create and manage IAM Roles, Policies, and OIDC provider.

## Define Allowed Action Sources

You'll be prompted for the `repo_name` variable from Terraform. This expects the format in `org/repo`. You can also specify this via a tfvars file by  renaming the [terraform.tfvars.example](./terraform.tfvars.example) file to `terrform.tfvars` and adjusting the `repo_name` accordingly.

By default, this will allow assuming roles for Github Actions which are either running as part of:

- A Pull Request
- On the `main` branch

For more information about possible criterias, please visit [Github Docs](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token)

## IAM Actions

By default the `policy` object grants Administrator access to the AWS IAM Role. You can - and probably should - modify this as per your requirements.

## OpenID Connect Provider

An instance of the OIDC provider for GitHub Actions is created that can be deployed once per account.

## Output

The ARN of the role is provided as the output.

## Usage

To use this application:

1. Clone the repository onto your local system.
2. Install the dependencies using `npm install`
3. Customize the allowed sources and IAM actions as necessary in the  [main.w](./main.w) file.
4. Deploy the setup by running the Winglang application using the deploy script:

```
./deploy.sh
```

This process will prompt for the repository name, which is not stored and will therefore need to be entered again during subsequent runs.

For ease of use, consider renaming the [terraform.tfvars.example](./terraform.tfvars.example) file to `terrform.tfvars` and adjusting the `repo_name` accordingly.

```
cp terraform.tfvars.example terraform.tfvars
```

### Cleanup

For destroying resources and cleaning up, you can use the `./destroy.sh` script.

### Terraform State

The [deploy](./deploy.sh) generates the Terraform state in the root folder of the project as `terraform.tfstate`. Make sure to retain this file for any future updates or for easy destruction of created resources.

For multi-user setups or organizational contexts, you may want to consider other Terraform [backend options](https://www.winglang.io/docs/guides/terraform-backends) which may be more suitable for you.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check issues page if you want to contribute.
