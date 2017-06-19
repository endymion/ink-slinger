module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
      sass: {
          options: {
              sourceMap: true
          },
          dist: {
            files: [{
                expand: true,
                cwd: 'public/sass',
                src: ['**/*.scss'],
                dest: 'public/css',
                ext: '.css'
              }]
          }
      }
    });

    // Load required modules
    grunt.loadNpmTasks('grunt-sass');

    // Task definitions
    grunt.registerTask('default', ['sass']);
};
