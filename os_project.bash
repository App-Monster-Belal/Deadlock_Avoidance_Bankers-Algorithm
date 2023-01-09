#!/bin/bash

#this script will help you to find the safe sequence for a deadlock avoidance

#declaring the global variables

declare -a available
declare -a need
declare -a allocation
declare -a sequence

#prompting the user for the number of processes

echo -n "Please enter the number of processes: "
read n

#prompting the user for the resources

echo -n "Please enter the number of resources: "
read m

#storing the available resources

echo "Please enter the available resources:"
for ((i=1; i<=m; i++ ))
do
  read a
  available[i]=$a
done

#storing the maximum need matrix

echo "Please enter the maximum need matrix:"
for ((i=1; i<=n; i++ ))
do
  echo "Maximum need for process $i:"
  for ((j=1; j<=m; j++ ))
  do
    read b
    need[i,j]=$b
  done
done

#storing the allocation matrix

echo "Please enter the allocation matrix:"
for ((i=1; i<=n; i++ ))
do
  echo "Allocation for process $i:"
  for ((j=1; j<=m; j++ ))
  do
    read c
    allocation[i,j]=$c
  done
done

#initializing the sequence

for ((i=1; i<=n; i++ ))
do
  sequence[i]=0
done

#function to check whether a process can be executed or not

function CheckProcess {
  local f=0
  for ((j=1; j<=m; j++))
  do
    if [[ ${need[$1,$j]} -gt ${available[$j]} ]]
    then
      f=1
    fi
  done
  return $f
}

#function to update available resources

function UpdateAvailable {
  for ((j=1; j<=m; j++))
  do
    available[j]=$((${available[$j]} + ${allocation[$1,$j]}))
  done
}

#fuction to find the safe sequence

function FindSequence {
  local count=0
  for ((i=1; i<=n; i++))
  do
    CheckProcess $i
    if [[ $? -eq 0 ]]
    then
      sequence[$i]=$i
      UpdateAvailable $i
      count=$(($count + 1))
    fi
  done
  return $count
}

#function to display the safe sequence

function DisplaySequence {
  echo -n "The safe sequence is: "
  for ((i=1; i<=n; i++))
  do
    echo -n "${sequence[$i]} "
  done
  echo ""
}

#executing the functions

FindSequence
if [[ $? -eq $n ]]
then
  DisplaySequence
else
  echo "System is not in safe state!"
  exit 1
fi
