/*
 * http://www.thingiverse.com/thing:87677
 *
 * Snow plow attachment designed for Brio/Thomas style wooden trains.
 *
 * This vertical-print version is designed to look more like the plow on the
 * "Adventures of Thomas" train than the original pattern (thing:54071).  It
 * also has a tilted-up bottom edge of the blade to hopefully prevent it from
 * getting stuck when the toy train goes down a slope.
 *
 * The vertical printing alignment is designed to allow for the tilted bottom
 * edge, but also means that I was unable to print the tabs designed for the
 * original pattern to hold this onto the train.  Thus, you will have to use
 * the mounting-magnet cavity in order to use this accessory effectively with
 * your child's trains.  Just insert the magnet (after double-checking polarity)
 * and glue it into place with epoxy or by manually extruding plastic into the
 * hole.
 *
 * Mounting-magnet dimensions are based on:
 *
 *   http://www.cherrytreetoys.com/Ceramic-Magnet-P3616.aspx
 *
 * Copyright 2013 to Chris Petersen
 * License: http://creativecommons.org/licenses/by-sa/3.0/
 *
 * Find the latest versions of this and other related designs at:
 *
 *   https://github.com/ex-nerd/3d
 */

/* [Global] */

// Render support structure?
support = true;

/* [Hidden] */

/*
 * Render the snow plow
 */
module plow($fn=75) {
    // Basic configuration
    w = 25.4; // Width of plow
    h = 22; // Height of plow
    d = 20;   // Depth (distance to tip) of plow (plus a little extra for the bullnose effect)
    // The height of the mounting block that extends behind the plow
    mount_height=h-5.4;
    // Radius of the hole to cut for the train's magnet to be insert into (adjusted for shrinkage)
    mount_radius = (mount_height/2)-1;
    magnet_radius = 6.8;

    /*
     * Creates one side of the curve of the plow blade.
     * Intended to be mirrored.
     */
    module half_cutout() {
      hull() {
        translate([70,34,h+10])
          scale(v=[1,1,.05])
              sphere(r=75);
        translate([46,52,0])
          scale(v=[1,1,.05])
            sphere(r=50);
      }
    }

    /*
     * Creates both sides of the curve of the plow blade.
     * Intended to be used with difference().
     */
    module cutout() {
      union() {
        mirror([0,1,0])
          half_cutout();
        half_cutout();
      }
    }

    /*
     * The plow blade
     */
    module blade() {
      difference() {
        translate([0,-w/2-5,0]) {
          union() {
            cube(size = [d,w+10,h+5]);
            // bullnose
            translate([d-4,w/2+5,4.8])
              sphere(6);
          }
        }
        cutout();
        // peak
        translate([-.01,-w/2-6,h-2]) rotate([0,-45,0])
            cube(size = [14,w+12,6]);
        // This tilts the tip of blade of the plow slightly upwards.
        translate([14,-w/2-6,-h])
          rotate(a=[0,-25,0])
            cube(size = [d*2,w+12,h]);
      }
    }

    /*
     * Plow blade and assembly to mount it to a wooden train.
     */
    rotate([0,-90,0]) {
        difference() {
            union() {
            difference() {
              union() {
                blade();
                 // magnet cavity holder
                translate([-4,-w/2,0])
                  cube(size = [5,w,mount_height]);
              }
              // Train-magnet cavity
              translate([4,0,mount_radius+(mount_height/2-mount_radius)])
                rotate([0,-90,0])
                  hull() {
                    translate([0,0,-4]) cylinder(r=mount_radius, h=14+1);
                    translate([0,0,-10])
                      cylinder(r=magnet_radius-4, h=14+1);
                  }
            }
            // Support blocks
            if (support) {
              translate([0,0,0]) difference() {
                union() {
                  // plow peak support
                  translate([-4,-w/2,h-2.5])
                    cube(size = [4.01,w,3]);
                }
                translate([-4,-w/2,h+.75]) rotate([0,30,0])
                  cube(size = [5,w+1,4]);
              }
            }
          }
          // edges
          translate([-6,-w/2+5.2+.01,-.1]) rotate([0,0,236])
            cube(size = [6,20,h+5]);
          translate([-6,w/2-5.2-.01,-.1]) rotate([0,0,34])
            cube(size = [20,6,h+5]);
        }
    }
}

plow();