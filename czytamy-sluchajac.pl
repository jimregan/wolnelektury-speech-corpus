#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDOUT, ":utf8");

use HTTP::Request;
use Web::Scraper;
use Data::Dumper;
use HTTP::Headers;
use LWP::UserAgent;
use URI;

my $catalogue = 'https://wolnelektury.pl/katalog/audiobooki/';

my $booklister = scraper {
    process '//div[@id="books-list"]/div/div/p', "books[]" => scraper {
        process '//p/a', 'uri' => '@href';
    };
};

my $bookinfo = scraper {
    process '//div[@class="book-box-inner"]', 'info' => scraper {
        process '//a[.="MP3"]', 'mp3' => '@href';
        process '//a[.="TXT"]', 'text' => '@href';
        process '//span[@class="artist"]', 'artist' => 'TEXT';
    };
    process '//a[contains(.,"XML")]', 'source' => '@href';
};

my $booksres = $booklister->scrape(URI->new($catalogue));

for my $book (@{$booksres->{'books'}}) {
    if(exists $book->{'uri'}) {
        procpage($book->{'uri'});
    }
}

sub procpage {
    my $uri = shift;
    my $infores = $bookinfo->scrape(URI->new($uri));

    my $out = "$uri\t";
    
    if(exists $infores->{'info'}->{'artist'}) {
        $out .= $infores->{'info'}->{'artist'} . "\t";
    } else {
        die "No artist found: $uri\n";
    }

    if(exists $infores->{'info'}->{'text'}) {
        $out .= $infores->{'info'}->{'text'} . "\t";
    } else {
        $out .= "\t";
        print STDERR "WARNING: No text found: $uri\n";
    }

    if(exists $infores->{'info'}->{'mp3'}) {
        $out .= $infores->{'info'}->{'mp3'} . "\t";
    } else {
        die "No MP3 found: $uri\n";
    }

    if(exists $infores->{'source'}) {
        $out .= $infores->{'source'} . "\n";
    } else {
        die "No source found";
    }
    print $out;
}