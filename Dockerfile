FROM mcr.microsoft.com/dotnet/framework/aspnet:#{mainTag}#
RUN md c:\aspnet-startup
COPY Helpers/ c:/aspnet-startup
ENTRYPOINT ["powershell.exe", "c:\\aspnet-startup\\Startup.ps1"]