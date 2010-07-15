module Permalink
  module ClassMethods
    def has_permalink(field)
      include InstanceMethods
      class_inheritable_accessor  :permalink_field
      write_inheritable_attribute :permalink_field, field
      before_save :generate_permalink
      validates_uniqueness_of field
      key :permalink, String
    end

    def permalink_for(name)
      name.downcase.gsub(/\W/, '-').
                    gsub(/-+/, '-').
                    gsub(/-$/, '').
                    gsub(/^-/, '')
    end
  end

  module InstanceMethods
    def to_param
      permalink
    end

    protected
      def generate_permalink
        self.permalink = self.class.permalink_for(self[permalink_field])
      end
  end # InstanceMethods
end # Permalink
MongoMapper::Document.append_extensions(Permalink::ClassMethods)