bring cloud;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as aws;

let repoName = new cdktf.TerraformVariable(
  type: "string",
  description: "The name of the GitHub repository in the format 'org/repo'",
) as "repo_name";

// What sources are allowed to trigger this action?
// Please adapt this to your needs.
// Find more information at https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#understanding-the-oidc-token
let actionSources = [
  // allow pull requests
  "repo:${repoName.stringValue}:pull_request",
  // allow "main" branch
  "repo:${repoName.stringValue}:ref:refs/heads/main"
];

// What IAM actions does this action need?
// Please adapt this to your needs.
let policy = {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*",
      ],
      "Resource": [
        "*"
      ]
    }
  ]
};

// this is the OIDC provider for GitHub Actions and can only be deployed once per account
let oidcProvider = new aws.iamOpenidConnectProvider.IamOpenidConnectProvider(
  clientIdList: ["sts.amazonaws.com"],
  thumbprintList: [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ],
  url: "https://token.actions.githubusercontent.com",
);

let role = new aws.iamRole.IamRole(
  namePrefix: "wing-github-action",
  assumeRolePolicy: Json.stringify({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Federated": oidcProvider.arn
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": actionSources
                }
            }
        }
    ]
  }),
);

let iamPolicy = new aws.iamPolicy.IamPolicy(
  namePrefix: "wing-github-action",
  policy: Json.stringify(policy),
);

new aws.iamRolePolicyAttachment.IamRolePolicyAttachment(
  role: role.name,
  policyArn: iamPolicy.arn,
);

new cdktf.TerraformOutput(
  value: role.arn,
) as "oidc_role_arn";
