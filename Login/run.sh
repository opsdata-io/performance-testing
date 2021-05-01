register_post_data()
{
RandomData=$1
  cat <<EOF
{
    "name": "${RandomData}",
    "email": "${RandomData}@email.test",
    "password": "${RandomData}"
}
EOF
}

login_post_data()
{
RandomData=$1
  cat <<EOF
{
    "email": "${RandomData}@email.test",
    "password": "${RandomData}"
}
EOF
}


task(){
  echo "Creating account for $1"
  rm -f cookie-"$1".txt
  echo "Registering user..."
  curl -s -k -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "$(register_post_data $1)" "${URL}/api/register"
  echo ""
  echo "Logging in..."
  curl -s -k -i -H "Accept: application/json" -H "Content-Type:application/json" -b cookie-"$1".txt -c cookie-"$1".txt -X POST --data "$(login_post_data $1)" "${URL}/api/login"
  echo ""
  echo "Getting user data..."
  curl -s -k -i -H "Accept: application/json" -H "Content-Type:application/json" -b cookie-"$1".txt -c cookie-"$1".txt -X GET "${URL}/api/user"
  echo ""
  echo "Logout..."
  curl -s -k -i -H "Accept: application/json" -H "Content-Type:application/json" -b cookie-"$1".txt -c cookie-"$1".txt -X POST "${URL}/api/logout"
  echo ""
  echo "Cleaning up cookie..."
  rm -rf cookie-"$1".txt
}

while true;
do
  EPOCH=`date +%s`
  RandomName=`echo "$POD_NAME"_"$EPOCH"`
  task "$RandomName"
done
