# NAME

Mojo::File::Share - Extension to Mojo::File to find shared/installed files

# SYNOPSIS

    use Mojo::File::Share;

    # These will result in the same thing
    my $path = Mojo::File::Share->new("My-Application");
    my $path = Mojo::File::Share->new("My::Application");
    my $path = Mojo::File::Share->new(My::Application->new);

    # Example full application
    package MyApp;

    sub startup {
      my $self = shift;

      # Change public and templates directories to share/ path
      Mojo::File::Share->to_app($self);
    }

    # Example Makefile.PL
    use File::ShareDir::Install;
    install_share 'share';

# DESCRIPTION

[Mojo::File::Share](https://metacpan.org/pod/Mojo::File::Share) is a merge of [File::ShareDir](https://metacpan.org/pod/File::ShareDir) and [File::Share](https://metacpan.org/pod/File::Share), but
also allows you to modify a [Mojolicious](https://metacpan.org/pod/Mojolicious) application with ease.

Note: In the same way as [File::Share](https://metacpan.org/pod/File::Share), this module does not support
per-module share directoris.

To install the files in "share/", you need something like
[File::ShareDir::Install](https://metacpan.org/pod/File::ShareDir::Install).

# FUNCTIONS

[Mojo::File::Share](https://metacpan.org/pod/Mojo::File::Share) implements the following functions, which can be imported
individually.

## dist\_path

    my $path = dist_path;
    my $path = dist_path "Some-Dist", @path;
    my $path = dist_path "Some::Module", @path;
    my $path = dist_path $some_object, @path;

Construct a new [Mojo::File::Share](https://metacpan.org/pod/Mojo::File::Share) object. Follows the same rules as ["new"](#new).

# METHODS

[Mojo::File::Share](https://metacpan.org/pod/Mojo::File::Share) inherits all methods from [Mojo::File](https://metacpan.org/pod/Mojo::File) and implements the
following new ones.

## new

    my $path = Mojo::File::Share->new;
    my $path = Mojo::File::Share->new("Some-Dist", @path);
    my $path = Mojo::File::Share->new("Some::Module", @path);
    my $path = Mojo::File::Share->new($some_object, @path);

Construct a new [Mojo::File::Share](https://metacpan.org/pod/Mojo::File::Share) object with `$path` set to either the
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

## to\_app

    my $path = Mojo::File::Share->to_app($mojo_app);
    my $path = Mojo::File::Share->new("What-Ever")->to_app($mojo_app);

Used to apply the "public" and "templates" directories to you [Mojolicious](https://metacpan.org/pod/Mojolicious)'s
[Mojolicious::Static](https://metacpan.org/pod/Mojolicious::Static) and [Mojolicious::Renderer](https://metacpan.org/pod/Mojolicious::Renderer) objects.

# AUTHOR

Jan Henning Thorsen

# COPYRIGHT AND LICENSE

Copyright (C), Jan Henning Thorsen.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[File::ShareDir::Install](https://metacpan.org/pod/File::ShareDir::Install)

[File::ShareDir](https://metacpan.org/pod/File::ShareDir)

[File::Share](https://metacpan.org/pod/File::Share)
