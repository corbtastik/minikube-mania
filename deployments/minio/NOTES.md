# MinIO Notes

Miscellaneous information about [MinIO](https://min.io/) Object Storage.

## IAM

MinIO IAM is built with AWS Identity and Access Management (IAM) compatibility at its core and presents that framework to applications and users no matter the environment - providing the same functionality across varying public clouds, private clouds and the edge.

MinIO extends AWS IAM compatibility with support for popular external identity providers such as ActiveDirectory/LDAP, Okta and Keycloak, allowing administrators to offload identity management to their organization's preferred SSO solution.

## Authentication

[MinIO IAM](https://min.io/product/identity-and-access-management)

Authentication is the verification of "who" a connecting user and/or application is and their right to claim that identity.

Users don't log into Object Stores, applications do. Object Storage IAM should support both manual (static) and programmatic (dynamic) application-focused identity management.

* For manual identity creation, admins can use the Object Store Admin Console.
* For programmatic identity creation, admins can use `mc` command line interface.
* Object Storage should support internal identity management and the ability to integrate with external identity providers (IDP) that specialize in creation, authentication, and management of user identities.
* Identities follow access-key and secret-key credential framework.
* OpenID (OIDC) compatible providers
  * Google
  * Facebook
  * Okta
  * OpenLDAP
  * Active Directory
* When using external IDPs, applications must use MinIO Secure Token Service (STS) API to provision self-expiring user credentials.
  * __TODO__ Why?
* In addition to internal and external user identities the MinIO Admin Console supports the creation of __Service Accounts__.
* __Service Accounts__ are simple identities consisting of an automatically generated access-key and secret-key. Service Accounts are linked to the user account that created it.
* Support for [certificate based authentication](https://blog.min.io/certificate-based-authentication-with-s3/)

### S3 compatibility

* S3 soley relies on authenticating using static access-key and secret-key credentials shared between the S3 client and S3 server.
  * Managing a large number of static secret keys is a security nightmare
  * Manually managing dynamic secret keys is an organizational nightmare
* S3 protocol contains an extension - the Secure Token Service (STS)
  * STS is a way to request temporal secret keys
  * STS supports OpenID Connect (OIDC) for human authentication
  * OIDC has an interactive authentication flow not suited for automated services

### Client Certificates

* MinIO has implemented another STS authentication type using client certificates.
  * Called: __AssumeRoleWithCertificate__
* S3 client requests ephemeral S3 access credentials by authenticating itself via X.509 TLS certificates.
* S3 client has a TLS client certificate issued by a certificate authority (CA) and hits the AssumeRoleWithCertificate API. The S3 server receives the client certificate as part of the HTTPS connection and verifies its authenticity (i.e. verifies its been issued by a trusted CA).
* The S3 server maps the certificate to an S3 policy using the certificates Common Name (CN).
  * If such a policy exists the S3 server generates a new ephemeral access-key, secret-key pair and sends to S3 client.
  * S3 client can perform S3 operations.
* __Advantages__
  * Certificate based authentication requires a TLS connection, the S3 access credentials cannot be leaked over an insecure network connection.
  * Certificates are the standard way to prove the identity of a service on the internet and widely supported across SDKs and programming languages.
  * Certificate based authentication is "offline", the CA does not need to be online whenever authentication happens unlike external OIDC. This improves availability and fault tolerance.
  * Certificates are temporal, they expire and become invalid.
* [AssumeRoleWithCertificate docs](https://github.com/minio/minio/blob/master/docs/sts/tls.md#assumerolewithcertificate)

## Key Elements

Key Element: Platform, Security, Authentication
Object Storage IAM should support both manual (static) and programmatic (dynamic) application authentication.

S3 compatible authentication relies on using static access/secret key credentials shared between the client and server. Support for static access/secret key credentials is expected as a base level for all Object Storage platforms. However managing a large number of static credentials becomes a security challenge at scale, yet implementing dynamic access/secret key credentials is taxing from a technical perspective.

Thus as a next level of maturity Object Storage platforms should support use of Secure Token Service authentication via client X.509 certificates. Object Storage clients request ephemeral credentials by authenticating via X.509 certificates. The Object Storage platform receives the client certificate as part of the HTTPS connection, verifies its authenticity from a Certificate Authority (CA), then maps the client certificate Common Name (CN) to an identity. If the identity is known ephemeral access/secret keys are generated and exchanged with the client to perform Object Storage operations. Dynamic certificate based authentication methods have the following advantages over static access/secret key credentials.

Certificate based authentication requires a TLS connection, thus S3 access/secret key credentials cannot be leaked over insecure network connections.
Certificates are the standard way to prove the identity of network services, and widely supported across languages and SDKs.
Certificates are temporal, they expire and become invalid.

Key Element: Platform, Security, Identity Management
Object Storage platforms should support internal identity management and the ability to integrate with external Identity Providers (IDP) that specialize in creation, authentication, and management of identities.

Use of external Identity Providers should support identities and authentication for human users, not application based identities. Application based identities should standard Object Storage IAM with static access/secret key credentials or ideally client certificates with dynamic access/secret key credentials. 

