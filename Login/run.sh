register_post_data()
{
RandomData=$1
  cat <<EOF
{
    "name": "TestUser_${RandomData}",
    "email": "${RandomData}@email.test",
    "password": "Passw0rd"
}
EOF
}

login_post_data()
{
RandomData=$1
  cat <<EOF
{
    "email": "${RandomData}@email.test",
    "password": "Passw0rd"
}
EOF
}


task(){
rm -f cookie-"$1".txt
echo "Registering user..."
curl -k -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-X POST --data "$(register_post_data $1)" "${URL}/api/register"
echo ""
echo "Logging in..."
curl -k -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-b cookie-"$1".txt -c cookie-"$1".txt \
-X POST --data "$(login_post_data $1)" "${URL}/api/login"
echo ""
echo "Getting user data..."
curl -k -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-b cookie-"$1".txt -c cookie-"$1".txt \
-X GET "${URL}/api/user"
echo ""
echo "Logout..."
curl -k -i \
-H "Accept: application/json" \
-H "Content-Type:application/json" \
-b cookie-"$1".txt -c cookie-"$1".txt \
-X POST "${URL}/api/logout"
echo ""
echo "Cleaning up cookie..."
rm -rf cookie-"$1".txt
echo ""
}

while true;
do
  RandomNumber=$(( ( RANDOM % 999999 )  + 1 ))
  task "$RandomNumber"
done
