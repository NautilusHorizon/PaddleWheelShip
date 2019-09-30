
$fa = 1;
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
        cylinder(h=max_radius*2,r=t_height+thickness/2,center=true);
        
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
    
//            translate([0,radius*0.6,0]) 
//            scale([1,0.75,1])
//            cylinder(h=thickness*2,r=width*0.25,center=true);
//
//            translate([0,radius*0.25,0]) 
//            scale([1,0.75,1])
//            cylinder(h=thickness*2,r=width*0.25,center=true);

        }
    }
//    radii = [
//        0.77*radius, 
//        0.425*radius,
//    ];
//    radial_t_height = width*0.25;
//    radial_ts(thickness, t_thickness, radial_t_height, radii);
//    
//    translate([0,0,width])
//    mirror([0,0,1])
//    radial_ts(thickness, t_thickness, radial_t_height, radii);
}

module connectors(radius=35, width=20, thickness=2,
                  num_connectors=4, t_thickness=2, 
                  tube_radius=3)
{
    multiply_rotate(num_connectors)
    connector(radius, width, thickness, t_thickness=t_thickness);
    
    cylinder(h=width, r=tube_radius);

    translate([0,0,0]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);

    translate([0,0,width-t_thickness]) 
    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);


    translate([0,0,(width-t_thickness*4)*0.5]) 
    cylinder(h=t_thickness*4, r=tube_radius+radius*1/35.);

}


module paddle(radius=65, width=30, thickness=2, t_thickness=1)
{
    paddle_length = radius*0.4;
//    paddle_yaw = -22; paddle_pitch = +5;
//    paddle_yaw = +22; paddle_pitch = -5;
    paddle_yaw = 0; paddle_pitch = 0;
    
    difference()
    {
    }
    translate([0, radius-paddle_length/2, width/2])
    rotate([0,0,paddle_yaw])
    {
        rotate([0,paddle_pitch,0])
        cube([thickness,paddle_length ,width], center=true);

        translate([0, -(radius-paddle_length/2), -width/2])
        {
            //translate([0, radius-paddle_length/2, 0]) 
            //#
            
            //translate([0, 0, width/2]) 

            enable_radial_ts = true;
            if(enable_radial_ts)
            {
                radii = [
                    radius-paddle_length+t_thickness/2, 
                    radius-paddle_length/2-t_thickness/2, 
                    radius-t_thickness/2,
                ];
                radial_t_height = width*0.5;
                
                radial_ts(thickness, t_thickness, radial_t_height*0.5, [radii[0]]);
                radial_ts(thickness, t_thickness, radial_t_height*1, [radii[1]]);
                radial_ts(thickness, t_thickness, radial_t_height*0.75, [radii[2]]);
                
                translate([0,0,width])
                mirror([0,0,1])
                {
                    //radial_ts(thickness, t_thickness, radial_t_height*0.5, [radii[0]]);
//                    radial_ts(thickness, paddle_length, radial_t_height*0.125, [
//                        radius-paddle_length/2
//                    ]);
                }
                
                //radial_ts(thickness, t_thickness, radial_t_height, radii);
            }
        }
    }
}

module paddles(radius=35,width=20,thickness=2,num_paddles=4,t_thickness=2, tube_radius=3)
{
    eps=1e-2;
    
    multiply_rotate(num_paddles)
    intersection()
    {
        translate([0,0,-eps]) cylinder(h=width+eps, r=radius);
        paddle(radius, width, thickness, t_thickness=t_thickness);
    }
    
    
//    cylinder(h=width, r=tube_radius);

//    translate([0,0,0]) 
//    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);
//
//    translate([0,0,width-t_thickness]) 
//    cylinder(h=t_thickness, r=tube_radius+radius*2/35.);


//    translate([0,0,(width-t_thickness*4)*0.5]) 
//    cylinder(h=t_thickness*4, r=tube_radius+radius*1/35.);

}

module attachment_disk(thickness=3,radius=35)
{
    color("red", alpha=0.8) cylinder(h=thickness, r=35);
}

module make_screw_holes(num_screws=5, screw_radius=2.5, screw_distance=13, stamp_length=20, rotation=[0,0,0])
{
    
    difference()
    {
        children();
        rotate(rotation)
        multiply_rotate(num_screws)
        {
            translate([0,screw_distance,-stamp_length/4])
            cylinder(h=stamp_length,r=screw_radius);
        }
    }
}

module multiply_rotate(num, rotation_axis=[0,0,1])
{
    rx = rotation_axis[0];
    ry = rotation_axis[1];
    rz = rotation_axis[2];
    for (k=[0:num-1])
    {
        rotation = k*360.0/num;
        rotate([rx*rotation, ry*rotation, rz*rotation])
        children();
    }
}

module wheel_attachment_disk(num=5, radius=35, disk_thickness=3, screw_radius=2)
{
    rotation_offset=(360/num)/2;
    
    make_screw_holes(num, screw_radius, 
        screw_distance=radius*0.37, stamp_length=disk_thickness*2, 
        rotation=[0,0,rotation_offset])
    attachment_disk(disk_thickness);
}

module make_holes_paddles_attachment(num=5, radius=35, disk_thickness=3, screw_radius=2)
{
    rotation_offset=(360/num)/2;
    
    make_screw_holes(num, screw_radius, 
        screw_distance=radius*0.75, stamp_length=disk_thickness*2, 
        rotation=[0,0,rotation_offset+rotation_offset*0.3333])
    make_screw_holes(num, screw_radius,
        screw_distance=radius*0.75, 
        stamp_length=disk_thickness*2, 
        rotation=[0,0,rotation_offset-rotation_offset*0.3333])
    make_screw_holes(num, screw_radius,
        screw_distance=radius*0.37, 
        stamp_length=disk_thickness*2, 
        rotation=[0,0,rotation_offset])
    
    children();
}

module paddles_attachment_disk(num=5, radius=35, disk_thickness=3, screw_radius=2)
{
    make_holes_paddles_attachment(num, radius, disk_thickness, screw_radius)
    attachment_disk(disk_thickness);
}

module wheel_attachment(radius=35, disk_thickness=2, outer_width=26, num_connectors=5, screw_radius=2.0)
{
    wheel_attachment_disk(num_connectors,radius,disk_thickness,screw_radius);
    
    translate([0,0,disk_thickness]) {
        
        color("gray") 
        cylinder(h=outer_width-disk_thickness*2,r=radius);
        // connectors(num_connectors=num_connectors, radius=radius, width=outer_width-disk_thickness*2);
        
        translate([0,0,outer_width-disk_thickness*2])
        paddles_attachment_disk(num_connectors,radius,disk_thickness,screw_radius);
    }
}

module paddle_wheel()
{
    paddle_disk_tube_radius = 3;
    paddle_disk_thickness = 2;
    paddle_width = 20;
    paddle_disk_radius = 65;

    // tube connecting disks
//    translate([0,0,0]) 
//    cylinder(
//        h=paddle_width+paddle_disk_thickness*2, 
//        r=paddle_disk_tube_radius);

    
    // inner disk
    color("darkblue",alpha=1.0)
    translate([0,0,0]) 
    make_holes_paddles_attachment(5, 35, paddle_disk_thickness)
    cylinder(h=paddle_disk_thickness, r=paddle_disk_radius);
//        
    translate([0,0,paddle_disk_thickness]) 
    {
        // outer disk
//        color("darkblue",alpha=1.0)
//        translate([0,0,paddle_disks_distance-1e-2])
//        cylinder(h=paddle_disk_thickness, r=paddle_disk_radius );
        
        
        // paddles
        color("orange") 
        translate([0,0,0]) 
        paddles(
            num_paddles=8,
            radius=paddle_disk_radius, 
            width=paddle_width);
    }    
}

module complete_paddle_wheel() 
{
    wheel_attachment();
    translate([0,0,26])
    paddle_wheel();
}

rotate([90,-0.25*360/5,0]) 
{
    translate([0,0,-35/2]) wheel();
    complete_paddle_wheel();
}