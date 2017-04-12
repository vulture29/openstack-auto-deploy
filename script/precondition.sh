#!/bin/bash

function before_install()
{
	#confirm the keystone
	#cleaning port
	yum install lsof;
	lsof -i :5000|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :35357|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :11211|grep -v "PID"|awk '{print "kill -9",$2}'|sh;

	#horizon

	#Neutron
	#install mysql
	yum install mysql-server;
	/sbin/service mysqld start;
	yum install lsof;
	yum install ebtables ipset;
	#clean up port
	lsof -i :5000|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :35357|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :11211|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :9696|grep -v "PID"|awk '{print "kill -9",$2}'|sh;

	#Glance
	yum install mysql-server;
	/sbin/service mysqld start;
	yum install lsof;
	#clean up port
	lsof -i :5000|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :35357|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :11211|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :9292|grep -v "PID"|awk '{print "kill -9",$2}'|sh;

	#Nova
	yum install lsof;
	#clean up port
	lsof -i :5000|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :35357|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :11211|grep -v "PID"|awk '{print "kill -9",$2}'|sh;
	lsof -i :8774|grep -v "PID"|awk '{print "kill -9",$2}'|sh;

}