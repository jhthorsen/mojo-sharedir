# NAME

Mojo::ShareDir - Shared files and directories as Mojo::File objects

# SYNOPSIS

    use Mojo::ShareDir;

    # These will result in the same thing
    my $path = Mojo::ShareDir->new("My-Application");
    my $path = Mojo::ShareDir->new("My::Application");
    my $path = Mojo::ShareDir->new(My::Application->new);

    # Example Makefile.PL
    use File::ShareDir::Install;
    install_share 'share';

# DESCRIPTION

[Mojo::ShareDir](https://metacpan.org/pod/Mojo%3A%3AShareDir) is a merge of [File::ShareDir](https://metacpan.org/pod/File%3A%3AShareDir) and [File::Share](https://metacpan.org/pod/File%3A%3AShare)

Note: In the same way as L <File::Share>, this module does not support
per-module share directories.

To install the files in "share/", you need something like
[File::ShareDir::Install](https://metacpan.org/pod/File%3A%3AShareDir%3A%3AInstall).

# FUNCTIONS

[Mojo::ShareDir](https://metacpan.org/pod/Mojo%3A%3AShareDir) implements the following functions, which can be imported
individually.

## dist\_path

    my $path = dist_path;
    my $path = dist_path "Some-Dist", @path;
    my $path = dist_path "Some::Module", @path;
    my $path = dist_path $some_object, @path;

Construct a new [Mojo::ShareDir](https://metacpan.org/pod/Mojo%3A%3AShareDir) object. Follows the same rules as ["new"](#new).

# METHODS

[Mojo::ShareDir](https://metacpan.org/pod/Mojo%3A%3AShareDir) inherits all methods from [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) and implements the
following new ones.

## new

    my $path = Mojo::ShareDir->new;
    my $path = Mojo::ShareDir->new("Some-Dist", @path);
    my $path = Mojo::ShareDir->new("Some::Module", @path);
    my $path = Mojo::ShareDir->new($some_object, @path);

Construct a new [Mojo::ShareDir](https://metacpan.org/pod/Mojo%3A%3AShareDir) object with `$path` set to either the
local "share/" path or the installed for a given distribution.

Will throw an exception if the distribution cannot be found.

To resolve the shared path, these rules will apply:

- No arguments

    Will use the caller package name.

- A dist name

    To resolve the local path, by converting the dist name into a module name, and
    look it up in `%INC`. This means the module need to be loaded.

- A module name

    See "A dist name" above.

- An object

    Will find the class name for the object and apply the same rule as for "A
    module name".

# AUTHOR

Jan Henning Thorsen

# COPYRIGHT AND LICENSE

Copyright (C), Jan Henning Thorsen.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[File::ShareDir::Install](https://metacpan.org/pod/File%3A%3AShareDir%3A%3AInstall)

[File::ShareDir](https://metacpan.org/pod/File%3A%3AShareDir)

[File::Share](https://metacpan.org/pod/File%3A%3AShare)
