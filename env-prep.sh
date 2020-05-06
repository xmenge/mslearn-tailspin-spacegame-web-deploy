## script to provision environment for further deployment

# set variables
SUFFIX=3000
DEV_NAME=tailspin-space-game-web-dev-$SUFFIX
TEST_NAME=tailspin-space-game-web-test-$SUFFIX
STAGING_NAME=tailspin-space-game-web-staging-$SUFFIX
RG=tailspin-space-game-rg

# set default location 
az configure --defaults location=australiaeast


# create resource group
az group create --name $RG


# create app service plan of F1 tier
az appservice plan create \
  --name tailspin-space-game-asp-devtest \
  --resource-group $RG \
  --sku F1


# create webapp for dev and test under app service plan of F1 tier
az webapp create \
  --name $DEV_NAME \
  --resource-group $RG \
  --plan tailspin-space-game-asp-devtest

az webapp create \
  --name $TEST_NAME \
  --resource-group $RG \
  --plan tailspin-space-game-asp-devtest


# create app service plan of S1 tier, which will enable adding slots
az appservice plan create \
  --name tailspin-space-game-asp-stageprod \
  --resource-group $RG \
  --sku S1


# create webapp for staging under asp of S1 tier
az webapp create \
  --name $STAGING_NAME \
  --resource-group $RG \
  --plan tailspin-space-game-asp-prod


# show webapp lsit
az webapp list \
  --resource-group $RG \
  --query "[].{hostName: defaultHostName, state: state}" \
  --output table


# adding extra slot and show all slots
az webapp deployment slot create \
  --name $STAGING_NAME \
  --resource-group $RG \
  --slot swap

az webapp deployment slot list \
    --name $STAGING_NAME \
    --resource-group $RG \
    --query "[].{hostName: defaultHostName, state: state}" \
    --output tsv



