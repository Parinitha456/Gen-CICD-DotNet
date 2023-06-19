# Use the official Microsoft .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the source code to the working directory
COPY . .

# Copy the project file to the working directory
COPY aspnet-get-started/aspnet-get-started.csproj .

# Restore the project dependencies
RUN apt-get update && apt-get install -y msbuild
RUN msbuild aspnet-get-started/aspnet-get-started.csproj /t:Restore
RUN nuget restore aspnet-get-started.sln


# Build the application
RUN msbuild aspnet-get-started/aspnet-get-started.csproj /t:Build /p:Configuration=Release

# Publish the application
RUN dotnet publish --configuration Release --no-restore --output /app/publish

# Use the official Microsoft .NET runtime image as the base image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the build stage to the final stage
COPY --from=build /app/publish .

# Expose the port the application will listen on
EXPOSE 80

# Set the entry point for the container
ENTRYPOINT ["dotnet", "YourProject.dll"]
