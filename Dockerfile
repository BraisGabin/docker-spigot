FROM java:8

# Install dependencies.
RUN apt-get update -y \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install gosu.
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& curl -o /usr/local/bin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -fsSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

ENV SPIGOT_USER="spigot" \
	SPIGOT_HOME="/var/lib/spigot/"

# Add user
RUN adduser --system --disabled-login --group --gecos "Spigot" --home $SPIGOT_HOME $SPIGOT_USER

# Download, build and install Spigot
RUN temp=`mktemp -d` \
	&& cd $temp \
	&& curl -o "BuildTools.jar" "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar" \
	&& java -XX:-UsePerfData -jar BuildTools.jar \
	&& mkdir -p /usr/local/share/spigot \
	&& mv spigot*.jar /usr/local/share/spigot/spigot.jar \
	&& cd / \
	&& rm -rf $temp

COPY /docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["gosu", "spigot", "java", "-Xms512M", "-Xmx1536M", "-jar", "/usr/local/share/spigot/spigot.jar"]

VOLUME ["$SPIGOT_HOME"]
WORKDIR $SPIGOT_HOME
EXPOSE 25565
