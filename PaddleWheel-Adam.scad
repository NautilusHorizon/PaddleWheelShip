
$fa = 5;
$fs = 1;
module rim(width=30, radius=21, screw_radius=5) 
{
    difference()
    {
        cylinder(h=width, r=radius, center=true);
        color(alpha=0) cylinder(h=width+5, r=screw_radius, center=true);
    }
}
module tire(width=35, radius=35, rim_radius=21) 
{
    difference()
    {
        cylinder(h=width, r=radius, center=true);
        color(alpha=0) cylinder(h=width+5, r=rim_radius, center=true);
    }
}

module wheel(tire_width=35, tire_radius=35, rim_width=30, rim_radius=21, screw_radius=5) 
{
    color("gray") rim(rim_width, rim_radius, screw_radius);
    color("black") tire(tire_width, tire_radius, rim_radius);
}

module radial_ts(thickness, t_thickness, t_height, radii)
{
    max_radius = max(radii);
    translate([0,0,t_height*0.5])
    intersection()
    {
        translate([
            0,
            max_radius,
            0
        ]) 
        rotate([90,0,0])
        cylinder(h=max_radius*2,r=t_height,center=true);
        
        for (radius = radii)
        {
            t_dist = radius;
            difference()
            {
                difference()
                {
                    
                    
                    translate([0,0,-1e-3])
                    cylinder(
                        h=t_height, 
                        r=t_dist+t_thickness*0.5, 
                        center=true);
                    cylinder(
                        h=t_height*2,
                        r=t_dist-t_thickness*0.5, 
                        center=true);
                    
                    
                    translate([
                        -t_height-thickness/2,
                        max_radius,
                        t_height*0.5
                    ]) 
                    rotate([90,0,0])
                    cylinder(h=max_radius*2,r=t_height,center=true);

                    translate([
                        +t_height+thickness/2,
                        max_radius,
                        t_height*0.5
                    ]) 
                    rotate([90,0,0])
                    cylinder(h=max_radius*2,r=t_height,center=true);
                }
    
            }
        }
    }
}

module connector(radius=35, width=20, thickness=2, t_thickness=1)
{
    difference()
    {
        translate([0,radius/2,width/2]) 
        cube([thickness,radius,width], center=true);
        
        
        rotate([0,90,0]) 
        translate([-width/2,0,0])
        {
            translate([0,radius,0]) 
            scale([1,0.5,1])
            cylinder(h=thickness*2,r=width*0.5,center=true);
    
            translate([0,radius*0.6,0]) 
            scale([1,0.75,1])
            cylinder(h=thickness*2,r=width*0.25,center=true);

            translate([0,radius*0.25,0]) 
            scale([1,0.75,1])
            cylinder(h=thickness*2,r=width*0.25,center=true);

        }
    }
    radii = [
        0.77*radius, 
        0.425*radius,
    ];
    radial_t_height = width*0.25;
    radial_ts(thickness, t_thickness, radial_t_height, radii);
    
    translate([0,0,width])
    mirror([0,0,1])
    radial_ts(thickness, t_thickness, radial_t_height, radii);
}

module connectors(radius=35,width=20,thickness=2,num_connectors=4,t_thickness=2, tube_radius=3)
{
    for (a=[0:num_connectors-1])
    {
        rotate([0,0,a*360/(num_connectors)])
        connector(radius, width, thickness, t_thickness=t_thickness);
    }
    
    cylinder(h=width, r=tube_radius);

    translate([0,0,0]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);

    translate([0,0,width-t_thickness]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);


    translate([0,0,(width-t_thickness*4)*0.5]) 
    cylinder(h=t_thickness*4, r=tube_radius+radius*1/35.);

}


module paddle(radius=65, width=40, thickness=2, t_thickness=1)
{
    paddle_length = radius*0.23;
    difference()
    {
        
        translate([0, radius-paddle_length/2, width/2]) 
        cube([thickness,paddle_length ,width], center=true);
        
        
//        rotate([0,90,0]) 
//        translate([-width/2,0,0])
//        {
//            translate([0,radius,0]) 
//            scale([1,0.5,1])
//            cylinder(h=thickness*2,r=width*0.5,center=true);
//    
//            translate([0,radius*0.6,0]) 
//            scale([1,0.75,1])
//            cylinder(h=thickness*2,r=width*0.25,center=true);
//
//            translate([0,radius*0.25,0]) 
//            scale([1,0.75,1])
//            cylinder(h=thickness*2,r=width*0.25,center=true);
//
//        }
    }
    radii = [
        radius-paddle_length+t_thickness/2, 
        radius-t_thickness/2,
    ];
    radial_t_height = width*0.5;
    
    //radial_ts(thickness, t_thickness, radial_t_height*0.5, [radii[0]]);
    radial_ts(thickness, t_thickness, radial_t_height, [radii[1]]);
    
    translate([0,0,width])
    mirror([0,0,1])
    {
        //radial_ts(thickness, t_thickness, radial_t_height*0.5, [radii[0]]);
        radial_ts(thickness, t_thickness, radial_t_height, [radii[1]]);
    }
    
    //radial_ts(thickness, t_thickness, radial_t_height, radii);
}

module paddles(radius=35,width=20,thickness=2,num_paddles=4,t_thickness=2, tube_radius=3)
{
    for (a=[0:num_paddles-1])
    {
        rotate([0,0,a*360/(num_paddles)])
        paddle(radius, width, thickness, t_thickness=t_thickness);
    }
    
    cylinder(h=width, r=tube_radius);

    translate([0,0,0]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);

    translate([0,0,width-t_thickness]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);


    translate([0,0,(width-t_thickness*4)*0.5]) 
    cylinder(h=t_thickness*4, r=tube_radius+radius*1/35.);

}

module attachment_disk(thickness=3,radius=35,num_screws=5, screw_radius=2.5, screw_distance=13)
{
    difference()
    {
        color("red", alpha=0.8) cylinder(h=3, r=35);
        for (a=[0:num_screws-1])
        {
            rotate([0,0,a*360/(num_screws)])
            translate([0,screw_distance,-thickness/2])
            cylinder(h=thickness*2,r=screw_radius);
        }
    }

}

module paddle_wheel() 
{
    rotate([0,0,(360/5)/2]) attachment_disk(5);
    
    translate([0,0,3]) {
        color("gray") connectors(num_connectors=5,radius=35);

        translate([0,0,20]) 
        {
            paddle_disk_tube_radius = 3;
            paddle_disk_thickness = 3;
            paddle_disks_distance = 40;
            paddle_disk_radius = 65;

            // tube connecting disks
            translate([0,0,0]) 
            cylinder(
                h=paddle_disks_distance+paddle_disk_thickness*2, 
                r=paddle_disk_tube_radius);

            
            // inner disk
            color("blue",alpha=0.2)
            translate([0,0,0]) 
            cylinder(h=paddle_disk_thickness, r=paddle_disk_radius);
            
            translate([0,0,paddle_disk_thickness]) 
            {
                // outer disk
//                color("blue",alpha=1.0)
//                translate([0,0,paddle_disks_distance])
//                cylinder(h=paddle_disk_thickness, r=paddle_disk_radius );
                
                
                // paddles
                color("gray") 
                translate([0,0,0]) 
                paddles(
                    num_paddles=5,
                    radius=paddle_disk_radius, 
                    width=paddle_disks_distance);
            }
        }
    }
}

rotate([90,-0.25*360/5,0]) 
{
    //translate([0,0,-35/2]) wheel();
    paddle_wheel();
}