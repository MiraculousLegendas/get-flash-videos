# Using CPAN #

CPAN is a command line program that works much like a package manager to fetch a module and resolve any dependencies that module has. You need to run cpan with superuser privileges so either as root or using sudo.

`sudo cpan`

It will ask if it can auto configure stuff. Select yes. After a lot of text and possibly hitting yes a couple more times, you will then be at a prompt. To install a module, for example Compress::Zlib, type

`install Compress::Zlib`

It will connect to the internet and likely ask if it can install several other modules it needs to complete this task. All you have to do at these prompts is hit enter and it will soon finish. When you are back at the cpan prompt and ready to exit the program, type exit and hit enter.

# Data::AMF::Packet dependency error #

While most dependencies can be satisfied with cpan, a small few cannot. For our purposes, to install Data::AMF::Packet, you will need XML::LibXML, which due to requiring an underlying C library (libxml2) is not always available through CPAN. It can however be installed through regular repositories, for example in Debian or Ubuntu you can install the package libxml-libxml-perl and it will satisfy the dependency (or on Red Hat the package is perl-XML-LibXML). After installing the package through your repository you should have no errors installing Data::AMF::Packet through CPAN.