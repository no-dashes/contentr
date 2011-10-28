# coding: utf-8

module Contentr
  class Node

    # Includes
    include Mongoid::Document
    include Mongoid::Tree
    include Mongoid::Tree::Ordering
    include Mongoid::Tree::Traversal

    # Fields
    field :name,   :type => String
    field :slug,   :type => String, :index => true
    field :path,   :type => String, :index => true

    # Protect (other) attributes from mass assignment
    attr_accessible :name, :slug, :parent

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates_uniqueness_of :slug, scope: :parent_id, allow_nil: false, allow_blank: false
    validates_format_of     :slug, with: /^[a-z0-9\s-]+$/
    validates_presence_of   :path
    validates_uniqueness_of :path, allow_nil: false, allow_blank: false

    # Enforcements
    class_attribute :run_node_checks
    class_attribute :accepted_child_nodes
    class_attribute :accepted_parent_nodes
    self.run_node_checks       = true
    self.accepted_parent_nodes = [:any]
    self.accepted_child_nodes  = [:any]

    # Callbacks
    before_validation :generate_slug
    before_validation :rebuild_path
    before_save       :check_nodes
    before_destroy    :destroy_children

    # Scopes
    default_scope :order => 'position ASC'


    def self.find_by_path(path)
      self.where(path: path).try(:first)
    end

    def has_children?
      children.count > 0
    end

    def path=(value)
      raise "path is generated and can't be set manually."
    end

    def slug=(value)
      self.write_attribute(:slug, value.to_slug) if value.present?
    end

    protected

    def check_nodes
      return unless Contentr.run_node_checks
      raise UnsupportedParentNodeError unless self.accepts_parent?(self)
      raise UnsupportedChildNodeError  if parent.present? and not parent.accepts_child?(self)
    end

    def accepts_child?(node)
      return true if self.accepted_child_nodes.include?(:any)
      self.accepted_child_nodes.include?(node.class.name)
    end

    def accepts_parent?(node)
      return true  if self.accepted_parent_nodes.include?(:any)
      return true  if node.root? and self.accepted_parent_nodes.include?(:root)
      return false if node.root? and not self.accepted_parent_nodes.include?(:root)
      self.accepted_parent_nodes.include?(node.class.name)
    end

    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_slug
      end
    end

    def rebuild_path
      self.write_attribute(:path, "/#{ancestors_and_self.collect(&:slug).join('/')}")
    end

  end

  class UnsupportedChildNodeError < RuntimeError; end

  class UnsupportedParentNodeError < RuntimeError; end

end
