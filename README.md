# BACperl #

## Introduction ##

BACnet-perl is set of perl modules, which implements functionality of BACnet communication protocol.

## Implemented Services of Application layer ##

| Service                     | Request | Response |
|-----------------------------|:-------:|:--------:|
| ConfirmedCOVNotification    |   No    |   Yes    |
| UnconfirmedCOVNotification  |   No    |   Yes    |
| SubscribeCOV                |   Yes   |    No    |
| ReadProperty                |   Yes   |    No    |


## How to install manually ##

Installation works only on some UNIX like systems due to dependencies on another perl modules. If you run into trouble during installation checkout modules, on whitch this module depends and its availability for your system.

1. Open a terminal.

2. Go the root file of the repository.

3. Run ``perl Makefile.PL``.

4. Run ``sudo make``.

5. Run ``sudo make install``.


## How run tests manually##

1. Open a terminal.

2. Go the root file of the repository.

3. Run one of the following commands.

    1. ``prove -lr t`` - run all tests.
    2. ``perl  <<path to the test script>>`` - run only one test script.

