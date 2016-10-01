#!/bin/bash

cat > stub.sh << 'EOF'
#!/bin/sh
MYSELF=`which "$0" 2>/dev/null`
[ $? -gt 0 -a -f "$0" ] && MYSELF="./$0"
java=java
if test -n "$JAVA_HOME"; then
    java="$JAVA_HOME/bin/java"
fi
exec "$java" $java_args -jar $MYSELF "$@"
exit 1
EOF

cat stub.sh $1 > $1.run && chmod +x $1.run

rm -f stub.sh

exit 0
