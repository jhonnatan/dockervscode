FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS debug

#EXPOSE 5000
#ENV ASPNETCORE_URLS=http://*:5000

RUN mkdir /work/
WORKDIR /work/

COPY ./dockervscode.csproj /work/dockervscode.csproj
RUN dotnet restore

COPY . /work/
RUN mkdir /out/
RUN dotnet publish --no-restore --output /out/ --configuration Release

#install debugger for NET Core
RUN apt-get update
RUN apt-get install -y unzip
RUN curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l ~/vsdbg

ENTRYPOINT ["dotnet", "run"]

###########START NEW IMAGE###########################################
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as prod

RUN mkdir /app/
WORKDIR /app/
COPY --from=debug /out/ /app/
RUN chmod +x /app/ 
CMD dotnet dockervscode.dll