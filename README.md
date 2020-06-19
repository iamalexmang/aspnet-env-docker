# Dockerfile - ASP.NET Windows container with support for web.config overrides at startup

This repository holds a tokenized `Dockerfile` which allows for Windows containers running .NET Framework based ASP.NET Projects to overwrite configuration variables held in web.config, with environment variables.
The resulting image can be used just like microsoft/aspnet. At container startup, it'll perform these additional steps, in order:

1. If C:\web-config-transform\transform.config exists, it'll use this file to transform the Web.config
2. Override Web.config with environment variables:
- Environment variables prefixed with `APPSETTING_` will override the corresponding app setting value (without the prefix)
- Environment variables prefixed with `CONNSTR_` will override the corresponding connection string (without the prefix)
3. Override Web.config values with kubernetes secrets
- Secrets prefixed with `APPSETTING_` will override the corresponding app setting value (without the prefix)
Secrets prefixed with `CONNSTR_` will override the corresponding connection string (without the prefix)

# Container image usage

To containerize an existing ASP.NET 4.x application build on either one of the precreated images or the image you just built:

```Dockerfile
FROM amang/aspnet:4.8
WORKDIR /inetpub/wwwroot
COPY sample-aspnet-4x .
```

#### Notice that rather than using the official Microsoft ASP.NET images, the base image is pulled from the amang Docker Hub registry instead.

If you'd prefer to build your own image, follow the [steps below](#build-your-own-base-aspnet-env-docker-image).

# Build your own base `aspnet-env-docker` image

You can find several pre-created Docker Hub images [here](https://hub.docker.com/r/amang/aspnet/). The intent is to keep pushing new images based on the official ASP.NET images.

If the image you want isn't listed or if for other reasons you need to build your own image, you can either:
1. Setup an Azure Pipelines Continuous Integration pipeline to have the image built and pushed. More information [here](#1-setting-up-azure-pipelines-to-push-to-a-private-azure-container-registry).
2. Build the image locally and push it to the registry of your choice. More information [here](#2-building-the-image-locally)

## 1. Setting up Azure Pipelines to push to a private Azure Container Registry

A detailed description on setting up your own Continuous Integration pipeline in Azure DevOps was added [here](\Build\README.md).

## 2. Building the image locally

Once you have identified the version of the [mcr.microsoft.com/dotnet/framework/aspnet](https://hub.docker.com/_/microsoft-dotnet-framework-aspnet) image that you want to base the image on, update the Dockerfile by replacing the `#{mainTag}#` placeholder.

Here's an example:

```Dockerfile
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-20200527-windowsservercore-2004
...
```

Next, run `docker build` locally from the aspnet-env-docker folder, to build the image.

```powershell
PS> docker build -t yourrepo/aspnet .
```

# Contributions

This repository has been largely built on @anthonychu's [aspnet-env-docker](https://github.com/anthonychu/aspnet-env-docker) GitHub repository and the idea express in his 2016 blogpost, [Dockerizing ASP.NET 4.x Apps with Windows Containers](https://anthonychu.ca/post/overriding-web-config-settings-environment-variables-containerized-aspnet-apps/).

#### Please open up issues or reach out to me directly if you find that an official Microsoft ASP.NET container image is missing.

## Adding new base images to Docker Hub

The process for adding a new image to the [Docker Hub registry](https://hub.docker.com/r/amang/aspnet/) is, as follows:
1. Edit tags.txt
2. Add a new line based on the image tag.
- Typically, Microsoft ASP.NET container images will have more than a single tag assigned for the same image. You will want to add them all, as per the official image description, separated by a comma
- Make sure that the first tag on each line is unique. Typically, this will be the most descriptive image tag
3. Open up a pull-request with the edited tags.txt

## Any contributions are welcome too.
